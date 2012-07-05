Passenger 3.0.13 crash under ruby 1.9.3-p125
============================================

This repo includes the information needed to replicate Passenger 3.0.13 + ruby 1.9.3-p125 (via rbenv) crashing under sufficiently high concurrent connections when used as a module in Apache v2.2.21 on Mac OS X Lion 10.7.4.

There is an apache vhost in config/apache_vhost.conf, please add it to your Apache setup. In the vhost, remember to adjust the relevant paths for your system.

To reach the server on localhost, setup stress.dev in /etc/hosts:

    127.0.0.1 stress.dev

Passenger module include info used to replicate the problem

    LoadModule passenger_module /Users/narnach/.rbenv/versions/1.9.3-p125/lib/ruby/gems/1.9.1/gems/passenger-3.0.13/ext/apache2/mod_passenger.so
    PassengerRoot /Users/narnach/.rbenv/versions/1.9.3-p125/lib/ruby/gems/1.9.1/gems/passenger-3.0.13
    PassengerRuby /Users/narnach/.rbenv/versions/1.9.3-p125/bin/ruby

To replicate the crash, use ab. I had to warm up Passenger to 30 backends before it would actually crash, so multiple repeats may be required.

    ab -r -n 10000 -c 210 http://stress.dev/

While the benchmark is running, repeatedly run passenger-status until it starts returning ruby errors. At this point the crash report is generated and Passenger is restarted, but under the load it will continue to crash repeatedly.

A sample crash report from my system is included as ./crash_report.txt

If there is not enough concurrency, Passenger fails to crash. If Apache has MaxClients set to 200, it fails to crash. Only by increasing the MaxClients setting above 200 and increasing the concurrent load above 200, will Passenger crash.

I have replicated the problem with this setup on my 17" Macbook pro with 8GB of ram and last year's Sandy Bridge 2.3 GHz i7. We also replicated the same problem with a different setup but with similar load characteristics on our Mac Pro server (last year's model).

