# CDS

## Introduction

CDS (Controller Design Studio) designs and runs controller blueprint
archives (CBAs): the resource resolution, configuration and other
day-0 to day-n actions that SO calls during instantiation and later.

The documentation is on
[Read the Docs](https://docs.onap.org/projects/onap-ccsdk-cds/en/latest/).

## Components

Each component is a subchart that can be switched off with
`<component>.enabled: false`.

- `cds-blueprints-processor`: the runtime. It serves the REST API (port
  8080) and the gRPC API (port 9111), and stores CBAs in the database.
- `cds-command-executor`: runs the Python and Ansible scripts of a CBA
  (gRPC, port 50051).
- `cds-py-executor`: runs Python scripts of a CBA and hosts the artifact
  manager (gRPC, ports 50052 and 50053).
- `cds-sdc-listener`: receives SDC distributions and uploads the CBAs they
  contain to the blueprints-processor.
- `cds-ui`: the designer UI.
- the CDS database, deployed by this chart unless an external one is
  configured.

## Requirements

CDS is enabled with `cds.enabled: true` in the ONAP umbrella chart. It talks
to AAI, SDC (through `cds-sdc-listener`), SDNC and the Strimzi Kafka cluster.
The blueprints-processor and `cds-py-executor` share a ReadWriteMany volume
for deployed CBAs, so the storage class has to support RWX.

## Configuration

- `global.tracing.enabled`: export traces over OTLP to
  `global.tracing.collector.baseUrl`, sampling
  `global.tracing.sampling.probability` of them.
- `global.metrics.enabled`: create Prometheus Operator ServiceMonitors for
  the components that expose metrics.
- `flavor`, `global.flavor` and `flavorOverride`: pick the resource limits
  (`small`, `large` or `unlimited`) defined under `resources` in each
  component.
- Database: the name, user and password the blueprints-processor uses are
  in `cds-blueprints-processor.config.cdsDB`. Its connection to the SDNC
  database is in `cds-blueprints-processor.config.sdncDB`.
