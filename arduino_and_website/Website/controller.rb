require "rubygems"
require "sinatra"
require "serialport"
require 'sinatra/bootstrap'

register Sinatra::Bootstrap::Assets
# connection to serial monitor
port_str = "/dev/ttyACM0"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE
sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

configure do
  @@LED = 0
  @@ALARM = 0
  @@READ = 0                    # if true, reading from serialport
end

get '/' do
  @@READ = 0
  erb :index
end

 # Two pages loaded on home page
get '/top' do
  erb :video
end

get '/controls' do
  erb :controls
end

# Servo Functionalities
get '/left' do
  "Servo Left"
  sp.write('L')
  erb :controls
    redirect '/controls'
end

get '/right' do
  "Servo Right"
  sp.write('R')
  erb :controls
    redirect '/controls'
end

get '/forward' do
  "Servo in Original Position"
  sp.write('F')
  erb :controls
    redirect '/controls'
end

# Alarm Functionalities
get '/setalarm' do
  "Trigger Alarm"
  sp.write("C")
  @@ALARM = 1
  erb :controls
    redirect '/controls'
end

get '/disablealarm' do
  "Stop Alarm"
  sp.write("X")
  puts "X"
  @@ALARM = 0
  erb :controls
  redirect '/controls'
end
