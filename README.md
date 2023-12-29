# *pfSense-automation*

## Introduction

<center>

![pfSense+](https://shop.netgate.com/cdn/shop/products/pfSense_-Shopify-thumbnail_12c1b2b7-1793-4ce3-8fb2-e717f4614b8f_1024x1024.png?v=1644599010)

#### *Set of PHP and bash scripts used to automate common tasks on pfSense firewall/router appliance.*

</center>

In same cases I ran into, automating [pfSense](https://shop.netgate.com/products/pfsense-software-subscription) by [netgate](https://www.netgate.com/) configuration changes is vital. This project is being started solely for the reason of a specific automatic operation need. I needed to be able to automagically point my DNS forwarder (dnsmasq, really) to the currently reachable IP. Without this, I am not able to RDP to my work machines (and I'm simply refusing to use a computer with a screen so tiny that Your hands won't fit inbetween the screen and Your face...) in a nice and easy way and provide basic failover capabilities for my local network. The secondary aim is to provide means for incorporating pfSense into declaratively defined IaC codebase.

## Architecture

<center>

![System Architecture][def2]

#### *Figure 1 - System Architecture*

</center>

The system will initialy have a keepalive agent (running on the LAN network), set of config scripts, each performing a single configuration task (written in PHP, deployed and/or running on the pfSense), automation hooks, triggers, loops and timers/cronjobs running on the keepalive agent (written in bash) - these will be trigering wrappers (also running n the keepalive agent, calling the PHP scripts via ssh, using key-pair authentication against the ssh daemon on the pfSense). In a later stage I would like to add the other way around - since I can run run pretty much anything n the local agent (it runs Debian), I will be detecting events and parsing logs periodicaly on the pfSense also, generating events and triggering (bash/perl/python) on the keepalive agent. This Debian machine will be consecutively send requests to APIs, run scripts on remote machines, etc. This should later become n entry point for an external monitoring/automation system anywhere in the Internet

I'd like to stick to a microkernel low-level architecture for simple components with the need of broad extensability without the need of rebuilding the core component, while the overall (high-level) application/system architecture and design would be Microservices communicating with each other thru a central API gateway (HAProxy), in HA configuration (VRRP), as it will allow for reusable scripts (microservices) and easily manageable wrappers, grouping microservices into complex processes based on roles, environment, triggering event.

## System design

<center>

![Low-level Design][def]

#### *Figure 1 - Low-level SW component design - complex service - microkernels extended by separately developed and maintained modules/plugins*

</center>

The microservices are divided into two groups: 1. simple services (monolitic low-level architecture), and 2. complex services (microkernel architecture with mudular design)

[def]: static/low-level-design.png
[def2]: static/architecture-overview.png

# TODO
