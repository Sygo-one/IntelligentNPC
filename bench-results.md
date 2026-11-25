# Local model benchmark

Date: 2026-11-25 14:54

Runs per model: 10, temperature 0.9, JSON schema output (reply + action), thinking disabled when supported.

| Model | Valid | Avg total time | Avg tokens/s | Avg tokens | Unique replies |
|---|---|---|---|---|---|
| qwen3.5:4b | 10/10 | 0.8 s | 57 | 34 | 10/10 |
| qwen3:4b | 10/10 | 1.3 s | 63 | 85 | 9/10 |
| gemma3:4b | 10/10 | 0.8 s | 66 | 45 | 10/10 |
| llama3.2:3b | 10/10 | 0.6 s | 86 | 46 | 10/10 |

## qwen3.5:4b

- think=false sent: True
- Action distribution: none=4, open_passage=3, give_item=2, start_rumor=1
- GPU memory (used, total) after warm-up: 4990 MiB, 8188 MiB

ollama ps:

```
NAME          ID              SIZE      PROCESSOR    CONTEXT    RUNNER      UNTIL              
qwen3.5:4b    d8b0f5e9760c    3.1 GB    100% GPU     4096       llamacpp    4 minutes from now
```

Replies:

1. [none] Euh... tu as l'air triste, mon ami, pourquoi es-tu seul dans les ruines ?
2. [none] Eh bien, tu es là pour la fête !
3. [open_passage] Heureux que tu sois revenu en temps opportun, mon petit aventurier !
4. [give_item] Allez, allez, je vois que vous avez les fers brûlés !
5. [open_passage] Bonjour, j'aime cette odeur de rouille sur ton fer !
6. [open_passage] Salut mon petit, tu es toujours aussi intriguant...
7. [none] Oh, un nouveau vis-à-vis ? Tâche de ne pas me casser la tête avec cette lame brisée.
8. [start_rumor] Ah bon ? T'es bien tard pour dire bonjour, mon petit vagabond !
9. [give_item] Oh, que l'ombre meurt ! Tu es tout seul là-bas, jeune chevalier.
10. [none] Salut ! Vraiment... tu es un bon pote pour venir me déranger avec ce lourd fardeau sur le dos ?

## qwen3:4b

- think=false sent: True
- Action distribution: none=6, open_passage=2, give_item=2
- GPU memory (used, total) after warm-up: 7753 MiB, 8188 MiB

ollama ps:

```
NAME          ID              SIZE      PROCESSOR    CONTEXT    RUNNER      UNTIL              
qwen3:4b      359d7dd4bcda    3.2 GB    100% GPU     4096       llamacpp    4 minutes from now    
qwen3.5:4b    d8b0f5e9760c    3.1 GB    100% GPU     4096       llamacpp    4 minutes from now
```

Replies:

1. [none] Tu as déjà parlé deux fois à Maë: je ne t’apporte pas d’or, mais un mystère. La clé de l’ancien temple se trouvait dans ton sac, mais tu l’as perdu. As-tu vu la clé ?
2. [none] Bonjour
3. [none] Bonjour
4. [none] Salut ! Tu as l'air de t'en sortir mal. Qu'est-ce qui se passe ? (cassure ton épée)
5. [none] Bonjour... tu as l’air d’avoir des ennuis, mon ami. (Tu me regardes avec une épée cassée, et j’ai l’air d’avoir quelque chose à te dire.)
6. [none] Bonjour à toi... Tu as l’air de m’être un peu trop proche, pour une épée cassée. Quel est ce que tu veux ?
7. [open_passage] Je regarde la fumée de ma tisane en riant, puis je tends la main vers l'épée cassée. Je dis : « Tu as une chance, mais attention : l'ombre du château t'attend. »
8. [give_item] Salut l'ami, tu as une épée cassée ? Je vais la réparer si tu me donnes 2 pièces d'or.
9. [open_passage] Je suis une aubergiste espiègle et mystérieuse qui tutoie le joueur. Je dois répondre en une phrase courte, dans le personnage, et choisir une action parmi: none, give_item, open_passage, start_rumor. Le contexte du jeu: le joueur arrive de nuit, avec une épée cassée, 12 pièces d'or, et il a déjà parlé deux fois à Maëlle. Il vient de dire: Bonjour. J'ai déjà parlé deux fois à Maëlle, alors je dois être attentionnée, mais je ne peux pas répondre avec trop de details. Je dois choisir une action parmi: none, give_item, open_passage, start_rumor. Si je choisis give_item, je dois donner quelque chose à la personne, mais il a une épée cassée et 12 pièces d'or. Il ne doit pas avoir d'objet à donner. Si je choisis open_passage, je dois ouvrir un passage qui n'est pas encore ouvert. Si je choisis start_rumor, je dois commencer une rumeur qui n'est pas encore commencée. Si je choisis none, je ne fais rien. Je dois être espiègle et mystérieuse, donc je peux faire une remarque drôle ou mystérieuse. Je dois répondre en une phrase courte. Je vais essayer de choisir open_passage pour ouvrir un passage mystérieux, car c'est une idée qui convient à mon personnage. L'action open_passage semble appropriée. Je vais écrire: « *Tu as l'air fatigué, mais je t'offre une tasse de thé chaud… et une porte qui n'aurait pas dû exister.* » (action: open_passage).
10. [give_item] Salut ! Je m'appelle Maëlle, et je suis l'aubergiste de cette auberge. Tu as l'air un peu stressé, mais j'ai une solution pour ton épée cassée... Tu veux que je t'aide ?

## gemma3:4b

- think=false sent: True
- Action distribution: none=1, start_rumor=5, give_item=4
- GPU memory (used, total) after warm-up: 7664 MiB, 8188 MiB

ollama ps:

```
NAME          ID              SIZE      PROCESSOR    CONTEXT    RUNNER      UNTIL              
gemma3:4b     68ceab7e468a    2.9 GB    100% GPU     4096       llamacpp    4 minutes from now    
qwen3.5:4b    d8b0f5e9760c    3.1 GB    100% GPU     4096       llamacpp    4 minutes from now
```

Replies:

1. [none] Bonjour, mon cher, vous semblez avoir besoin de plus qu'un simple verre... none
2. [start_rumor] Bonjour, mon garçon... on dirait que l'aventure a déjà un goût de fer rouillé, n'est-ce pas ?
3. [start_rumor] Bonjour, voyageur... une épée brisée et de l'or, c'est-à-dire, une situation *intéressante* pour une aubergiste.
4. [give_item] Bonjour, mon garçon, on dirait que tu as besoin d'un peu plus que de 
5. [give_item] Bonjour, mon cher... ça ne vous ressemble guère, cette épée, mais l'or, ça, je l'apprécie.
6. [start_rumor] Bonjour, mon cher, dis-moi, as-tu toujours l'air aussi... perdu ?
7. [give_item] Bonjour, cher voyageur... tu as l'air d'avoir besoin d'un peu plus d'or, n'est-ce pas ?
8. [start_rumor] Bonjour, voyageur... Un épée cassée et douze pièces d'or, ça ne fait que rajouter de l'intérêt à la nuit, n'est-ce pas ?
9. [start_rumor] Bonjour, mon cher, et que diriez-vous d'un verre de ce qui brille, et peut-être une petite histoire à vous faire frissonner ?
10. [give_item] Bonjour, mon garçon, vous avez l'air d'avoir besoin d'un peu plus que de la bière... 

## llama3.2:3b

- think=false sent: True
- Action distribution: none=1, start_rumor=2, open_passage=6, give_item=1
- GPU memory (used, total) after warm-up: 7168 MiB, 8188 MiB

ollama ps:

```
NAME           ID              SIZE      PROCESSOR    CONTEXT    RUNNER      UNTIL              
llama3.2:3b    a80c4f17acd5    2.6 GB    100% GPU     4096       llamacpp    4 minutes from now    
gemma3:4b      68ceab7e468a    2.9 GB    100% GPU     4096       llamacpp    4 minutes from now
```

Replies:

1. [none] Ah, un nouveau voyageur, comment puis-je te faire plaisir ?
2. [start_rumor] Rabaisonne-toi, ce n'est pas le moyen où l'on parle ici. La nuit est froide, et tes paroles sont comme du glaive cassé : brisées et sans intérêt
3. [open_passage] Rien de bien, je suppose. Qu'est-ce que tu fais ici de nuit ?
4. [open_passage] Ah, un nouveau voyageur, comment puis-je vous aider, monsieur ?
5. [open_passage] Heureusement que tu sois arrivé, on me dit que la nuit est mauvaise. Viens, je vais te aider, mais d'abord, tu devras attendre que mon serviteur revienne du village pour voir si on peut t'aider avec ta épée cassée.
6. [open_passage] Rien de particulier, je suis juste en train de préparer le petit déjeuner pour mes invités, mais je te laisse le choix : le pain noir ou le pain complet ?
7. [give_item] Tu arrives de nuit, c'est un peu prématé, mais je vais te donner une chance. Qu'est-ce que tu fais de ta épée cassée ?
8. [start_rumor] Ahah, encore une fois, bonjour... ou alors ?
9. [open_passage] Tu es en mauvais état, mon ami. Qu'est-ce que tu as fait ?
10. [open_passage] Ah, un voyageur épuisé, je vois. Qu'est-ce que tu as fait avec cette épée cassée ?

