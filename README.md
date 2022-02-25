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
terraform apply -var="root_password=<template_root_password>" \
    -var="ansible_private_key=<path_to_key>"
```

Optionnellement, il est possible de définir une liste de tags à ne pas exécuter (séparés par une virgule). Ils sont à spécifier de la sorte :

```bash
terraform apply -var="root_password=<template_root_password>" \
    -var="ansible_private_key=<path_to_key>" \
    -var="skip_tags=tag1,tag2"
```
