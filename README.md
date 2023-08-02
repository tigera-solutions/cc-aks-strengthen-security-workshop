# AKS and Calico blueprints hands-on workshop: <br> Strengthen security posture of app & K8s cluster

## Welcome

In this AKS-centric workshop, participants will work closely with Calico Cloud, a comprehensive networking and security solution provided by Tigera.  Throughout the workshop, we will explore a range of security features and best practices tailored for AKS deployments, learning to implement robust network security measures, enforce access controls, and fortify AKS environments against potential threats.

The purpose of this repository is to offer you a comprehensive, step-by-step guide on registering your AKS cluster on Calico Cloud, and securing your cloud-native applications to meet compliance requirements. Although Calico Cloud provides a wide range of functionalities and security features, this workshop will concentrate on a few key features used to protect your workload in runtime and deployment time. If you would like to delve deeper into this topic, please don't hesitate to contact us.

## Time Requeriments

The estimated time to complete this workshop is 60-90 minutes.

## Target Audience

- Cloud Professionals
- DevSecOps Professional
- Site Reliability Engineers (SRE)
- Solutions Architects
- Anyone interested in Calico Cloud :)

## Learning Objectives

Learn how to:
- **Scan container images** and **block deployment** of vulnerable images.
- Preview and **enforce security policies** to protect vulnerable workloads.
- Implement **zero-trust access controls** and **micro-segmentation** to improve the security posture.

## Workshop Environment Preparation

> **NOTE**: For this workshop it is expected that you have access to an AKS cluster previously created.

- Please follow the instructions on the repository below, if you don't have it ready: 

  [Calico Cloud on AKS - Workshop Environment Preparation](https://github.com/tigera-solutions/aks-workshop-prep)

- We will start this workshop from the Azure Cloud Shell, as described in that repository.

## Modules

This workshop is organized in sequencial modules. One module will build up on top of the previous module, so please, follow the order as proposed below.

Module 1 - [Connect the EKS cluster to Calico Cloud](/mod/module-1-connect-calicocloud.md)  
Module 2 - [Scan Container Images](/mod/module-2-scan-images.md)  
Module 3 - [Calico Cloud Admission Controller](/mod/module-3-admission-controller.md)  
Module 4 - [Implement zero-trust access controls and micro-segmentation](/mod/module-4-security-guardrails.md)  
Module 5 - [Clean up](/mod/module-5-clean-up.md)  

--- 

### Useful links

- [Project Calico](https://www.tigera.io/project-calico/)
- [Calico Academy - Get Calico Certified!](https://academy.tigera.io/)
- [O’REILLY EBOOK: Kubernetes security and observability](https://www.tigera.io/lp/kubernetes-security-and-observability-ebook)
- [Calico Users - Slack](https://slack.projectcalico.org/)

**Follow us on social media**

- [LinkedIn](https://www.linkedin.com/company/tigera/)
- [Twitter](https://twitter.com/tigeraio)
- [YouTube](https://www.youtube.com/channel/UC8uN3yhpeBeerGNwDiQbcgw/)
- [Slack](https://calicousers.slack.com/)
- [Github](https://github.com/tigera-solutions/)
- [Discuss](https://discuss.projectcalico.tigera.io/)

> **Note**: The examples and sample code provided in this workshop are intended to be consumed as instructional content. These will help you understand how Calico Cloud can be configured to build a functional solution. These examples are not intended for use in production environments.


