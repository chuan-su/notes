# EC2

# Tenancy Placement

Tenancy defines how EC2 instances are distributed across physical hardware and affects pricing. There are three tenancy options available: 

- Shared (`default`) — Multiple AWS accounts may share the same physical hardware.

- Dedicated Instance (`dedicated`) - Ensures all EC2 instances that are launched in a VPC run on hardware that's dedicated to a single customer *( Dedicated Instances may share hardware with other instances from the same AWS account that are not Dedicated Instances)*. 

- Dedicated Host (`host`) — Your instance runs on a physical server with EC2 instance capacity fully dedicated to your use, an isolated server with configurations that you can control *(To use a tenancy value of host, you must use a launch template)*. 

### VPC tenancy

When you create a launch configuration, the default value for the instance placement tenancy is null and the instance tenancy is controlled by the tenancy attribute of the VPC. 

| Launch configuration tenancy | VPC tenancy=default      | VPC tenancy=dedicated |
| :-----                       | :----                    | :----                 |
| not specified                | shared-tenancy instances | Dedicated Instances   |
| `default`                    | shared-tenancy instances | Dedicated Instances   |
| `dedicated`                  | Dedicated instances      | Dedicated Instances   |

Note that: 

- Some `AWS services or their features` won't work with a VPC with the instance tenancy set to dedicated.
- Some `instance types` cannot be launched into a VPC with the instance tenancy set to dedicated. 

# Placement Group

- `Cluster` groups launch each associated instance into a **single availability zone** within close physical proximity to each other. This provides **low-latency** network interconnectivity and can be useful for **high-performance** computing (HPC) applications, for instance.

- `Spread` groups separate instances physically across distinct hardware racks and even availability zones to reduce the risk of failure-related data or service loss. Such a setup can be valuable when you’re running hosts that **can’t tolerate multiple concurrent failures**.

- `Partition` groups is in the middle, that places a small group of instances across distinct underlying hardware to reduce correlated failures. Partition placement groups can be used to deploy large distributed and **replicated** workloads, such as HDFS, HBase, and Cassandra, across distinct racks.

### Enhanced Networking

Enhanced networking uses single root I/O virtualization (SR-IOV) to provide high-performance networking capabilities on supported instance types. SR-IOV is a method of device virtualization that provides higher I/O performance and lower CPU utilization when compared to traditional virtualized network interfaces. Enhanced networking provides higher bandwidth, higher packet per second (PPS) performance, and consistently lower inter-instance latencies. There is no additional charge for using enhanced networking.

#### Elastic Fabric Adapter (EFA)

- EFA OS-bypass traffic is limited to a single subnet. In other words, EFA traffic cannot be sent from one subnet to another. Normal IP traffic from the EFA can be sent from one subnet to another.

- EFA OS-bypass traffic is not routable. Normal IP traffic from the EFA remains routable.

- The EFA must be a member of a security group that allows all inbound and outbound traffic to and from the security group itself.

#### Differences between EFAs and ENAs

- Elastic Network Adapters (ENAs) provide traditional IP networking features that are required to support VPC networking.
- EFAs provide all of the same traditional IP networking features as ENAs, and they also support OS-bypass capabilities. OS-bypass enables HPC and machine learning applications to bypass the operating system kernel and to communicate directly with the EFA device. 

#### Lifecycle hook 

![Lifecycle hook](https://docs.aws.amazon.com/autoscaling/ec2/userguide/images/auto_scaling_lifecycle.png)

### Elastic IP address
An Elastic IP address doesn’t incur charges as long as the following conditions are true:

- The Elastic IP address is associated with an Amazon EC2 instance.
- The instance associated with the Elastic IP address is running.
- The instance has only one Elastic IP address attached to it.

### Read More:    	

- [Configuring instance tenancy with a launch configuration](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-dedicated-instances.html)
- [Placement Group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html)
