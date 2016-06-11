require 'rubygems'
require "sinatra"
require 'serialport'
require "twilio-ruby"
require 'firebase'

# setup firebase
FB_uri = "https://amber-heat-814.firebaseio.com/"
firebase = Firebase::Client.new(FB_uri)

# connection to serial monitor
port_str = "/dev/ttyACM0" # change this to appropriate port
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE
sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

# initializing SMS messaging using Twilio
acct_sid = "ACc69757aac028f471087979779b8674ac"
auth_token = "e2c9ee46d629a1a0c43679a54e49aa5d"
client = Twilio::REST::Client.new acct_sid, auth_token

from = "+17786554118" # my Twilio number
to = "+17785525268"
#
# sec = 60
# counter = 0
# puts Time.now
# flag = 0;
#
# loop{
#   i=sp.gets
#   if(i != nil)
#     i = i.chomp
#   end
#   if(i == 'S')
#     if(flag==0)
#       now = Time.now
#       puts now
#     end
#     flag = 1;
#   end
#   if(i == 'D')

#     flag = 0;
#   end
#
#   if(Time.now >= now + sec)
#     puts Time.now
#     if(flag==1)
#       client.account.messages.create(
#         :from => from,
#         :to => to,
#         :body => "Hey fellas" )
#     end
#   end
# }
#
#######################
# Declare variables
$text = 0
$timesUp
$temperature = 0

#flags
temp = 35

#Thread.new do
  loop do
    i = sp.gets                     # get the next byte from serial port
    if(i != nil)                    # if it's not nil, find matching command
    #  i = i.chomp
      print i
      j = i.chomp
      case j
      when 'S'                      # if byte is 'S', motion sensor went off, 30
          $text = 1                # second timer triggered to disable alarm
          currentTime = Time.now    # before text sent
          print currentTime
          $timesUp = currentTime + 60
          print $timesUp
        when 'D'
	  puts 'D'   
          $text = 0                # 'D' means alarm is disabled
        when '1'
          puts "no command"
        else
          $temperature = i
          firebase.update('', {temp: $temperature})
          #print "Temperature: "
          #print $temperature
          #print " "
          # send message if temp is greater than threshold
          #if(i.to_i >= temp)
            #client.account.messages.create(
            #  :from => from,
            #  :to => to,
            #  :body => "Warning, the ambiant temperature of your house is: " + i + ". Your house may be on fire.")
          #end

      end
      if($timesUp != nil)
        puts "time is up"
        if ($text == 1 && Time.now > $timesUp) # time is up, sending text
          puts "sending text"
          client.account.messages.create(
              :from => from,
              :to => to ,
              :body => "Warning, motion was detected at your house. Your house may be have been broken into. Call 911 if necessary" )
          $text = 0
        end
      end
    end
  end
#end
