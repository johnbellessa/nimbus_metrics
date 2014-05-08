# Nimbus Metrics

## Installation
1. Get [rvm](https://rvm.io/)
2. `rvm install ruby-2.1.0`
3. Update bundle (the version I got was broken...)
  - `gem install bundle`
4. Get [homebrew](http://brew.sh/) (OSX) or [linuxbrew](https://github.com/Homebrew/linuxbrew) (Linux)
5. Install thrift (this'll take a min)
  - `brew install thrift`
6. Clone the Repo:
  - `git clone https://github.com/rsprabery/nimbus_metrics.git`
7. Install dependencies
  - `bundle install`

You'll also need to make sure that you have a `~/storm/storm.yaml` configured with
`nimbus.host: NIMBUS_IP` for the metrics script to work.

## Usage

`metrics.rb QUERY_SECONDS TIME_LENGTH_MINUTES OUTPUT_DIR`
- QUERY_SECONDS - How frequently to collect metrics
  - defaults to `5` seconds
- TIME_LENGTH_MINUTES - How long to query a single topology
  - defaults to `.5` minutes
- OUTPUT_DIR - Where to store the output
  - defaults to `./runs`

**Examples**

1. `metrics 5 .5 ./runs`
  - This will query nimbus every 5 seconds for info and  will collect metrics
for .5 minutes.  All output will be in `./runs/TOPOLOGY_NAME/*.csv`.
2. `metrics 30 10 ../some_other_dir/runs`
  - This will query nimbus every 30 seconds for info and  will collect metrics
for 10 minutes.  All output will be in
`../some_other_dir/runs/TOPOLOGY_NAME/*.csv`.



The `metrics.rb` script is a long running process, it will start collecting
metrics when a topology is submitted in a new thread and will stop after
TIME_LENGTH_MINUTES for that topology, but will continue looking for new
topologies.  If a topology is killed before TIME_LENGTH_MINUTES is up, that
topology's thread quits running in `metrics.rb`, but doesn't affect the main
thread.
