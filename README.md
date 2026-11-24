# IntelligentNPC

Système de PNJ intelligent et réutilisable pour Unreal Engine 5.7, conçu pour rendre chaque interaction courte, imprévisible et donner envie de revenir parler au personnage.

> **Statut : projet en cours de développement** (MVP prévu sur 4 semaines).

## Objectif

Concevoir une brique modulaire de PNJ, indépendante du jeu, qui :

- **Surprend le joueur** : chaque échange est court et peut révéler une réplique décalée, un secret, une mini-quête ou un événement rare (récompense variable, comme le « scroll » d'un réseau social).
- **Réagit au contexte** : le PNJ reçoit un résumé de la situation (lieu, actions récentes, inventaire) et répond par la parole ou par une action concrète dans le monde.
- **Fonctionne hors ligne** : un petit modèle de langage local (format GGUF, via llama.cpp) remplace tout service cloud, sans connexion ni coût par requête.

## Architecture prévue

- **Composant PNJ** (`UActorComponent`) à poser sur n'importe quel acteur.
- **Collecteur de contexte** : transforme l'état du jeu en résumé structuré.
- **Backend LLM interchangeable** : interface commune, pour passer d'un serveur local à un plugin embarqué sans modifier le reste du code.
- **Réponses structurées** (réplique + action parmi une liste autorisée), validées par le code du jeu.
- **Contenus écrits à la main** (secrets, mini-quêtes, événements rares avec probabilités) combinés au modèle pour la formulation.
- **Repli sans IA** si le modèle échoue ou répond trop lentement.

## Feuille de route

- [ ] Semaine 1 : faisabilité du modèle local dans UE5 (latence, qualité, format de réponse)
- [ ] Semaine 2 : composant PNJ réutilisable, collecte du contexte, génération asynchrone
- [ ] Semaine 3 : actions concrètes, pool d'événements rares, mémoire courte, interface de dialogue
- [ ] Semaine 4 : scène de démonstration, vidéo, documentation

## Technologies

- Unreal Engine 5.7 (C++)
- llama.cpp / modèles GGUF quantifiés
- Git et Git LFS

## Installation

À venir. Le modèle de langage n'est pas inclus dans le dépôt (taille) : les instructions de téléchargement seront ajoutées ici.

## Auteur

Projet personnel, réalisé dans le cadre de ma recherche d'un poste de développeur de jeux vidéo.
