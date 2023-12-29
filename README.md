# *pfSense-automation*

## Introduction

<center>

![pfSense+](https://shop.netgate.com/cdn/shop/products/pfSense_-Shopify-thumbnail_12c1b2b7-1793-4ce3-8fb2-e717f4614b8f_1024x1024.png?v=1644599010)

#### *Set of PHP and bash scripts used to automate common tasks on pfSense firewall/router appliance.*

</center>

This initiative is primarily focused on enhancing the automation of pfSense configuration adjustments. The impetus for this endeavor is the necessity to dynamically align the DNS forwarder (specifically, dnsmasq) to an operational IP address. This capability is critical for ensuring efficient Remote Desktop Protocol (RDP) connectivity to workstations, circumventing the limitations of using devices with restricted screen sizes. Additionally, the project aims to facilitate the integration of pfSense into a imperatively structured Infrastructure as Code (IaC) framework, thereby augmenting our network's failover resilience and operational efficiency.

Infrastructure as Code (IaC) is a key concept in modern IT operations and systems engineering, fundamentally transforming how infrastructure is managed and provisioned. At its core, IaC is the process of managing and provisioning computing infrastructure through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.

This approach essentially treats servers, databases, networks, and other infrastructure elements as software code. IaC utilizes high-level descriptive coding languages to automate the setup and configuration of infrastructure, ensuring that the environment is spun up consistently and error-free. This is in stark contrast to traditional manual processes, which are often prone to human error and inconsistencies.

There are two primary styles of IaC: declarative and imperative. Declarative IaC, like Terraform, focuses on the final desired state of the infrastructure, specifying 'what' the infrastructure should look like, leaving the system to figure out 'how' to achieve it. On the other hand, imperative IaC, like Chef or Puppet, defines specific commands or scripts to reach the desired state, focusing on the 'how'.

One of the significant advantages of IaC is its ability to support DevOps practices, fostering collaboration between development and operations teams. By using IaC, organizations can quickly deploy and update infrastructure with minimal risk, ensuring that all changes are version controlled and testable, much like software code.

Moreover, IaC enables scalability and cloud adoption. With cloud computing's rise, managing large-scale, complex, and distributed systems has become more manageable. IaC tools can effortlessly provision and manage infrastructure across various cloud providers and on-premises environments, allowing for seamless scalability and flexibility.

In conclusion, IaC represents a paradigm shift in how infrastructure is managed, offering greater efficiency, consistency, and agility in deploying and maintaining IT systems. It's an indispensable tool in the modern IT landscape, particularly for organizations embracing cloud computing and DevOps methodologies.

## Architecture

<center>

![System Architecture][def2]

#### *Figure 1 - System Architecture*

</center>

The proposed system architecture encompasses an initial deployment of a keepalive agent within the LAN network. This agent is responsible for a suite of configuration scripts, each meticulously designed to execute distinct configuration tasks. These scripts, predominantly authored in PHP, are strategically deployed and operational on the pfSense framework. Additionally, the system integrates a series of automation mechanisms including hooks, triggers, loops, and timers/cron jobs, which are primarily executed on the keepalive agent using bash scripting.

The operational paradigm of this system involves the keepalive agent invoking wrappers, also situated on the same agent. These wrappers are tasked with executing the PHP scripts through SSH, employing key-pair authentication for secure communication with the SSH daemon on the pfSense.

The subsequent phase of development aims to introduce reverse interaction capabilities. Leveraging the flexibility of the local agent, which operates on a Debian environment, the system is designed to actively monitor and parse logs on the pfSense. This process facilitates the detection of events and the initiation of corresponding scripts in bash, perl, or python on the keepalive agent. The Debian-based machine plays a pivotal role in this ecosystem, orchestrating a diverse array of tasks including sending requests to APIs and executing scripts on remote machines.

Ultimately, this sophisticated setup is envisioned to evolve into a gateway for external monitoring and automation systems, accessible from any location across the Internet. This expansion signifies a significant enhancement in the system’s capabilities, offering extensive control and automation opportunities.

The envisioned system architecture adopts a microkernel approach for its low-level components, emphasizing simplicity and broad extensibility. This design choice ensures that these components can be extended without necessitating the reconstruction of the core component. At a higher level, the architecture is structured around the Microservices model, wherein various microservices communicate through a centralized API gateway, specifically utilizing HAProxy.

This high-level design is further enhanced by implementing a High Availability (HA) configuration using the Virtual Router Redundancy Protocol (VRRP). Such an arrangement facilitates the creation and utilization of reusable scripts embodied in the microservices. Additionally, it enables the efficient management of wrappers that coalesce these microservices into more intricate processes. These processes are delineated based on various factors such as their specific roles, the environment in which they operate, and the triggering events that initiate their execution.

This dual-level architectural strategy, combining the microkernel and microservices frameworks, offers a robust and flexible foundation. It allows for significant scalability and adaptability in the system’s development and operational phases, catering to evolving requirements and enhancing overall system efficiency.

## System design

<center>

![Low-level Design - Microkernel][def]

#### *Figure 1 - Low-level SW component design - complex service - microkernels extended by separately developed and maintained modules/plugins*

</center>

The microservices architecture in this system is bifurcated into two distinct categories: firstly, simple services, which adhere to a monolithic low-level architectural framework, and secondly, complex services, following a microkernel architecture characterized by a modular design. The simple services are designed for straightforward tasks, operating within a unified codebase, thereby simplifying development and deployment processes. In contrast, complex services are built on a microkernel architecture, facilitating flexibility and adaptability. This modular design allows for independent development and scaling of each module, enhancing the system's overall resilience and efficiency.

Humorously, the necessity for low-level architecture in simple services can sometimes be as overestimated as believing a teacup could serve as a swimming pool.

<center>

![Low-level Design - Monolithic design][def3]

#### *Figure 1 - Low-level SW component design - simple service - monolithic SW components with simple interface and a typically short execution time*

</center>

[def]: static/microkernel.png
[def2]: static/architecture-overview.png
[def3]: static/monolithic-microservice.png

# TBD soon
