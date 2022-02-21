# I1 - MSPR Archi Cloud

## Prérequis

L'utilisation de ce module nécessite d'avoir terraform d'installé sur son poste (ou sa machine de développement) et Ansible.

## Exécution (Linux / MacOS)
Avant le lancement du projet, les commandes suivantes doivent être exécutées:

```bash
export VSPHERE_USER=<VOTRE_USER>
export VSPHERE_PASSWORD=<VOTRE_PASSWORD>
export VSPHERE_SERVER=<VOTRE_SERVEUR>
```

Une fois ceci fait, il conviendra de faire un `terraform init` afin d'initialiser le projet. Enfin, afin de lancer la configuration, la commande suivante devra être exécutée :

```bash
terraform apply -var="root_password=<template_root_password>" -var="ansible_private_key=<path_to_key>" -var="gateway_ip=<ip_address>" -var="master_ip=<ip_address>" -var="worker1_ip=<ip_address>" -var="worker2_ip=<ip_address>"
```
