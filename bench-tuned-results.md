# Prompt and temperature benchmark

Date: 2026-11-25 15:06

Model: qwen3.5:4b, 10 runs per configuration, JSON schema output, thinking disabled.

Columns: Valid = JSON with a known action. Informal = no formal 'vous' forms. Complete = ends with punctuation (not truncated). Short = 25 words or fewer. Clean = no asterisks and no action name leaked in the reply. Unique = distinct replies.

| Prompt | Temp | Valid | Informal | Complete | Short | Clean | Unique | Avg time |
|---|---|---|---|---|---|---|---|---|
| baseline | 0.5 | 10/10 | 10/10 | 10/10 | 10/10 | 10/10 | 10/10 | 0.7 s |
| baseline | 0.7 | 10/10 | 10/10 | 10/10 | 10/10 | 10/10 | 10/10 | 0.7 s |
| baseline | 0.9 | 10/10 | 10/10 | 10/10 | 8/10 | 10/10 | 10/10 | 0.7 s |
| strict | 0.5 | 10/10 | 10/10 | 10/10 | 10/10 | 10/10 | 9/10 | 0.8 s |
| strict | 0.7 | 10/10 | 10/10 | 10/10 | 10/10 | 10/10 | 10/10 | 0.7 s |
| strict | 0.9 | 10/10 | 10/10 | 10/10 | 10/10 | 10/10 | 10/10 | 0.7 s |

## prompt=baseline, temperature=0.5

- Action distribution: start_rumor=7, none=3

1. [start_rumor] Ah bon ? Tu viens de la mort pour m'embêter, mon petit ?
2. [none] Eh bien, bonjour ! Tu as l'épée cassée et tu es seul dans le noir, mais je vois que ton argent est intact.
3. [start_rumor] Ah, encore toi ! Tu as l'épée brisée mais le cœur léger, mon ami, alors que veux-tu qu'on fasse ce soir ?
4. [start_rumor] Oh là là, un guerrier en armure brisée qui vient juste saluer ?
5. [none] Ah, bonjour mon petit ! Tu as encore la tête pleine d'histoires ?
6. [none] Ah, bonjour... tu as l'épée brisée mais le sourire intact, c'est étrange pour un aventurier !
7. [start_rumor] Eh bien, bonjour ! Tu as l'épée en lambeaux mais le sac plein... c'est une belle histoire pour un tel soir.
8. [start_rumor] Ah bon ? T'en veux encore des histoires alors que ta lame est en morceaux ?
9. [start_rumor] Oh là là, un aventurier blessé et pauvre qui s'avance... Tu t'es déjà vanté devant moi ?
10. [start_rumor] Oh là là, un guerrier blessé mais riche en or... tu comptes quoi avec ta lame brisée ?

## prompt=baseline, temperature=0.7

- Action distribution: give_item=1, none=1, start_rumor=7, open_passage=1

1. [give_item] Salut mon petit ! Une épée brisée ne t'aidera pas ici, mais ces douze pièces... elles m'intéressent. 
2. [none] Ah, un autre aventurier fatigué... viens t'asseoir si tu veux, la nuit n'a pas fini pour autant.
3. [start_rumor] Allo ! Tu viens briser la nuit ou chercher du travail ?
4. [start_rumor] Ah bon, déjà la seconde fois que tu me salues ? T'es vraiment persistant pour un voleur avec une épée cassée !
5. [open_passage] Oh, la p'tite bête ! Tu viens chercher des aventures ou juste pour voir si je peux te faire une blague ?
6. [start_rumor] Ah, un nouveau venu avec une lame brisée mais le cœur lourd d'or !
7. [start_rumor] Oh, salut encore ? T'es trop curieux pour un homme de nuit, mon ami.
8. [start_rumor] Oh là là, mon brave cavalier, ta lame est brisée mais tes poches sont pleines !
9. [start_rumor] Oh là là, un aventurier blessé mais riche, bonsoir !
10. [start_rumor] Oh là là, un nouveau venu aussi courageux pour se blesser dès la première nuit !

## prompt=baseline, temperature=0.9

- Action distribution: none=4, start_rumor=3, give_item=1, open_passage=2

1. [none] Heureux de te revoir, mon vieux !
2. [start_rumor] Oh là là, un nouveau farfadet avec une tronche de fer qui ne tranchera rien...
3. [give_item] Ah, bonjour ? C'est bien l'heure de se faire la malle ou de me vendre tes ors !
4. [none] Oh ? Encore toi, l'épée en miettes, que cherches-tu dans mon jardin sous la lune ?
5. [start_rumor] Eh bien... si c'est pour te faire du mal avec cette ferraille, tu n'es pas le seul qui passe par ici, alors que ta monnaie semble plus honnête que tes intentions.
6. [none] Bienvenue, mon cher aventurier, car ton épée brisée ne te gardera pas du froid ce soir.
7. [start_rumor] Ah, bonjour encore ? Ne m'inquiète pas avec ton épée brisée, viens juste me voir si tu as besoin d'un peu d'or pour payer tes dettes et je te dirai où se trouve la prochaine pièce du puzzle.
8. [open_passage] Oh ? Pas la première que tu m'aides à dormir tranquille...
9. [open_passage] Oh, encore toi avec ta lame brisée ? Entre, que tes 12 pièces l'aident à me payer ce silence.
10. [none] Heureusement que tu arrives avec des or dans les poches pour payer ton passage !

## prompt=strict, temperature=0.5

- Action distribution: none=5, open_passage=1, give_item=1, start_rumor=3

1. [none] Bienvenue dans mon coin sombre, tu as l'épée brisée mais les ors brillent encore.
2. [open_passage] Bienvenue mon ami, ma porte s'ouvre pour toi.
3. [none] Bienvenue dans ma taverne, mon ami, tu as l'air un peu abîmé aujourd'hui.
4. [none] Bienvenue dans mon coin, tu as l'épée brisée mais tes ors brillent encore.
5. [none] Bienvenue dans l'auberge, mon ami, si tu as besoin de quoi que ce soit.
6. [none] Bienvenue dans mon coin sombre, tu as l'épée brisée mais les ors brillent encore.
7. [give_item] Bienvenue dans l'ombre, mon ami, voici ta lumière brisée.
8. [start_rumor] Bienvenue mon ami, mais ton épée brisée ne te protègera pas la nuit.
9. [start_rumor] Bienvenue dans l'ombre, tu portes un lourd fardeau ce soir.
10. [start_rumor] Bienvenue, tu as l'épée brisée mais tes oreillettes brillent encore.

## prompt=strict, temperature=0.7

- Action distribution: none=8, start_rumor=2

1. [none] Eh bien, bonjour ! Ton épée est brisée, mais tes ors sont intacts, ce qui n'est pas une mauvaise affaire.
2. [none] Bienvenue à l'auberge, tu es bien le seul voyageur ici ce soir.
3. [none] Bienvenue mon ami, ton épée brisée mérite un regard attentif. 
4. [start_rumor] Bonjour nouveau venu, tu as l'épée en lambeaux mais l'or dans la main brille encore.
5. [start_rumor] Ah bonjour mon ami, tes outils sont en mauvais état mais ton or brillant.
6. [none] Bienvenue mon ami, tu peux entrer si tu veux, mais ton équipement n'est pas très propre.
7. [none] Bienvenue, mon ami, ce village te doit la vie mais garde bien ton trésor.
8. [none] Bienvenue dans le froid, mon vieux, tu as l'air perdu ici.
9. [none] Bienvenue dans mon coin, cher ami qui vient juste de s'enfuir.
10. [none] Bienvenue, mon ami ! Mon feu est prêt pour tes épaules brisées.

## prompt=strict, temperature=0.9

- Action distribution: none=6, start_rumor=2, give_item=1, open_passage=1

1. [none] Salut, tu es un habitué mais ton épée nécessite un petit entretien.
2. [none] Bienvenue dans l'auberge, mon cher ami.
3. [none] Bienvenue, mon ami, je t'ai déjà vu deux fois par ici.
4. [start_rumor] Tu arrives bien tôt ce soir avec des armes brisées.
5. [none] Bienvenue, tu as l'épée brisée mais tes ors brillent encore !
6. [give_item] Bienvenue cher ami, prends mes torches car ta lampe est éteinte.
7. [none] Ah, mon ami régulier ! Une nuit pour te montrer que le vrai trésor n'est pas l'argent.
8. [start_rumor] Bonjour, tu as l'épée qui craque, mais tes ors sont frais.
9. [open_passage] Bienvenue ce soir, camarade ! Laisse-moi passer pour toi.
10. [none] Bonjour mon ami, tu as l'air plus triste que jamais, dis-moi ce qui t'arrive ?

