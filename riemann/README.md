Riemann
========


[Riemann](http://riemann.io/) aggregates events from your servers and applications with a powerful stream processing language. Send an email for every exception raised by your code. Track the latency distribution of your web app. See the top processes on any host, by memory and CPU.


## Use in News
The conecept initially discussed in News was to use Riemann in conjunction with InfluxDB and Pyxis to be our alerting tool, sending messages to multiple services.  This would work by setting thesholds on the metrics sent from applications, with emails, pagerduty and Slack messages being sent.  

## Spike
Dave conducted a spike into usage, this repo includes the Riemann Dockerfile for fast setup time, instructions on how to setup the whole solution, as well as feedback from the spike

## Setup

The Docker way is to run a CollectD container, [configs here](https://github.com/revett/collectd-docker), with a Riemann container.  There is a shell script to aid in setting up and running the stack in this projects root directory.  There is also a script for stopping and removing the containers too.

## Viewing inputs

Once you have your docker stack running, the easist way to see what is going on is to install the riemann-dash gem `gem install riemann-dash`.  This is a rackapp, so run `riemann-dash` in your terminal and it should boot up a server on localhost:4567.  Once there, you will see a simple Riemann splash screen.  Follow these steps to view data :
- Put your docker host/boot2docker IP in the top right host:port box. E.g 192.168.59.103:5556
- CMD click the riemann logo, it should turn grey
- Type `e` to bring up edit screen
- Select flot from the dropdown
- Type true to see all data

You might have to zoom out to see all the stats as there are lots of metrics under true.  This will then show you all the data, with a prefix, in our case, of collectd-docker.  If you are using statsD, the stat might be collectd-docker statsd/derive-request, where collectd-docker is the host, statsd/derive is the plugin and request it the metric increment name.  This is now our chosen metric, we can filter everything out but that metric by editing the page, then entering `(service =~ "statsd/derive-request")`.  From now on, you should be able to determine new metrics, you can use regular expressions here to query multiple metrics under the same metric group.

## Config

By default, there are 2 alerts which send messages to slack.  This is basic setup for those wanting to see how Riemann works with Clojure and the Riemann DSL.

There are also a number of snippets in the examples.clj under the onbuild directory that show other types of alerts and data state checks.  Not all of these will work without support code.

I have installed and setup [riemann-extra](https://github.com/pyr/riemann-extra), which includes thresholds for use with metrics.  This can be used to simplify riemann and write less Clojure.

## Feedback
Riemann is very powerful, but the reliance on Clojure is moderate and will be an issue given how few people write it.  This is something we can come back to in the future, but without more experience across the team, it will be harder to use across /news.
