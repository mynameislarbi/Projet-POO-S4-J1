Projets : Un calendrier très très PÔÔ
1. Introduction

Assez de blabla, place à la pratique ! Les informations à assimiler aujourd'hui sont nombreuses : rien de mieux que la pratique pour se mettre dans le bain de la POO.

Aujourd'hui tu vas révolutionner le monde de la tech puisque tu vas créer un nouveau calendrier pour prendre des rendez-vous super efficacement. Pierre Valade n'a qu'à bien se tenir !

Tu vas coder une application où tu pourras créer des événements avec une date de début, une durée, et un nom. Tu pourras leur rattacher un lieu, des utilisateurs (qui y assisteront), et on affichera la liste totale des rendez-vous. L'avantage de penser "objet" pour ce genre d'application devrait assez vite te sauter aux yeux : sa décomposition sera extrêmement simple.
2. Le projet
2.1. Résumé et structure
2.1.1. Résumé

Le programme sera simple : nous allons faire une classe Event qui aura plusieurs variables d'instance : une date de début, une durée, un titre, ainsi que des participants. À partir de la date de début et de la durée, nous pourrons calculer (via des méthodes d'instance) si l'événement est passé ou s'il est prévu pour bientôt. Finalement, nous coderons une façon d'afficher l'événement de manière stylée.

Mais pour commencer en douceur, on va reprendre l'exemple utilisé dans le cours en codant la classe User en premier.
2.1.2. Structure

Puisque nous sommes super sympas et qu'on veut te faire gagner du temps, voici un repository vide qui contiendra notre application. La structure est très similaire à ce que l'on a vu jusque-là :

mon_projet
├── lib
│   ├── event.rb
│   └── user.rb
├── app.rb
├── README.md
├── Gemfile
├── Gemfile.lock
└── Autres fichiers (.env, .gitignore)

Seule nouveauté ? Comme expliqué dans le cours, le fichier app.rb va appeler les fichiers lib/event.rb et lib/user.rb. Bref c'est l'équivalent de ce qu'on faisait jusque-là avec la méthode perform 👌
2.2. On s'échauffe avec la classe User

Ton agenda va être utilisé par des gens, des utilisateurs qui vont créer des comptes et pouvoir s'inscrire. Dans le mode de pensée "orienté objet", on crée des classes pour les éléments concrets qui vont composer notre application : on va donc naturellement créer une classe User. C'est une classe très simple qui est parfaite pour t'échauffer.

Voici les spécifications de cette classe (= la liste de ce qu'elle doit pouvoir faire) : on veut pouvoir créer un utilisateur, lui attribuer un e-mail et un âge, puis obtenir facilement la liste des utilisateurs.
Si on traduit ça en langage "POO Ruby", voici ce que cela veut dire :

    On doit créer une classe User (thanks captain obvious !).
    Un User a 2 variables d'instance, un @email (string) et un @age (Integer), que l'on peut lire et modifier à sa guise (indice : attr_accessor).
    Dès la création d'un User, on veut définir son e-mail et son âge. En d'autres terme, on veut pouvoir faire julie = User.new("julie@email.com", 32)
    Il est possible de récupérer un array contenant tous les utilisateurs déjà créés. Cela doit se faire via une méthode de classe de la façon suivante : User.all.
        Celle-là n'est pas hyper simple quand on débute, c'est normal si tu prends une demi-heure dessus 😘 Inspire-toi de la ressource sur la POO (va voir la partie sur les variables de classe).
        Indices (ils sont en blanc sur blanc : surligne la phrase ci-après avec ta souris pour les révéler) :
        1) Il faut que tu crées une variable de classe @@all_users qui est un array.
        2) Puis, à chaque création d'utilisateur (dans le "initialize"), tu rajoutes le nouvel utilisateur dans cet array (utilise "self" pour faire référence à l'objet créé dans le initialize).
        3) Pour finir, il faut coder une méthode de classe "self.all" qui retourne simplement @@all_users. -fin des indices-
        Si jamais tu bloques trop dessus, passe à la suite et reviens dessus juste avec le 2.3.5

À toi de jouer : implémente un à un des points de la liste ci-dessus !
🚀 ALERTE BONNE ASTUCE

Avec nos require, on a branché le fichier app.rb à tous les autres. Donc une fois ta classe User écrite, tu peux tout à fait créer des utilisateurs, les modifier ou autre dans le code de app.rb. N'hésite pas à faire quelques tests en exécutant app.rb en ayant mis au préalable des puts ou des binding.pry dedans. Exemple : puts julie = User.new("coucou"), puts julie.email, etc.
2.3. Les événements

Fini de rigoler, on passe au cœur de l'app : notre classe Event. Voici ce que nous voulons faire avec nos objets événements :

    Un événement est défini par une date de début, une durée, un titre, un ou plusieurs utilisateurs.
    Il faut être capable de décaler un événement au lendemain, même heure.
    Il faut qu'il soit possible de récupérer des informations comme :
        La date de fin ;
        Savoir si un événement est passé ou non ;
        Savoir si un événement est dans moins de 30 minutes (au cas où nous voudrions envoyer un rappel).
    Il faut que l'on soit capables d'afficher de manière présentable un événement

OK, sauf si tu es déjà un champion de la POO, j'imagine que tout ceci ne t'inspire pas trop. Eh bien nous allons faire un petit pas à pas pour que tout aille bien ✌
2.3.1. Les attributs de l'événement

Voici les attributs (ou variable d'instance) que l'on voudra rajouter à notre événement :

    Un événement a une @start_date qui est de type Time (on y reviendra)
    Un événement a une @duration, qui est un integer qui représente le nombre de minutes
    Un événement a un @title, qui est un string
    Un événement a un ou plusieurs @attendees, qui est un array qui contient une liste d’e-mails

L'objectif de tout ça est de pouvoir rapidement (une ligne de code) créer un événement avec truc@machin.com et bidule@chose.fr en tant qu'invités :

Event.new("2019-01-13 09:00", 10, "standup quotidien", ["truc@machin.com", "bidule@chose.fr"])

Nous allons travailler attribut par attribut : suis le guide ci-dessous !
a) @start_date

Pour cet attribut, nous allons devoir manipuler des données de type Time, une fonctionnalité très cool de Ruby.
🚀 ALERTE BONNE ASTUCE

On va te présenter, en accéléré, le fonctionnement des objets de typeTime.

Lance IRB, puis fais : my_time = Time.now. Il devrait te renvoyer la date et l'heure exacte du moment, avec un truc du genre : 2019-01-23 12:03:14 +0100. C'est ça un objet de type Time !

Tu peux extraire chaque partie du Time avec par exemple (teste ça dans IRB) : my_time.year, my_time.min, etc.

Tu peux afficher le Time au format européen avec (teste ça dans IRB) my_time.strftime("%H:%M:%S %d/%m/%Y")

Tu peux facilement faire des opérations arithmétiques de bases en additionnant ou soustrayant des secondes. Par exemple avec my_time + 10 tu obtiens le même Time plus 10 secondes. Avec my_time + 3600, tu avances d'une heure (3600 secondes).

Une méthode qui nous intéresse est parse, qui permet de convertir un string en Time. Essaye donc de faire, dans IRB :

require 'time' #retourne "true"

Time.parse("2010-10-31 12:00") #=> 2010-10-31 12:00:00 +0100

Parfait, on a réussi à transformer un string au format "YY-MM-DD HH:mm" en un objet Time !

Avec tout ceci, tu devrais être armé pour bosser sur les événements. Mais si tu veux aller plus loin, tu peux tester ce tutoriel rapide (qui te présente des lignes à tester en IRB) ou carrément aller voir la liste des méthodes qui peuvent s'appliquer à un Time en allant sur la doc Ruby.

Mets donc la start_date en attr_accessor et arrange-toi pour qu'en tapant Event.new("2010-10-31 12:00"), on crée un Event ayant une start_date qui soit un objet de type Time même si "2010-10-31 12:00" est un string.
🤓 QUESTION RÉCURRENTE

Mais dis donc Jamy, pourquoi utiliser un type Time ?

C'est un format très pratique et assez standard en Ruby. On peut assez facilement le manipuler et notamment savoir (par exemple) si l'événement est dans le futur ou non.

Mais dis donc Jamy, ça change quelque chose si notre attr_accessor est un Time, array ou autre ?
Absolument pas. Tu peux mettre tout type de données en attr_accessor : integer, array, hash, etc. Nous verrons, quand tu seras bien à l'aise, les enjeux de ceci.
b) @duration

Maintenant, deuxième attribut : la durée de notre événement. Pour que ce soit simple, nous allons la représenter en un Integer qui sera le nombre de minutes de l'événement. Ainsi, si tu veux créer un événement de 30 minutes au dimanche 6 janvier 2019 à 14 h, il faudra rentrer :

Event.new("2019-01-06 14:00", 30)

Fais les changements adéquats dans le code de la classe Event et fais quelques tests depuis app.rb.
c) @title

Un événement a un titre ("point récap", "brainstorm", "rencontre avec Emmanuel", etc) qu'on voudra ajouter dès sa création. Si l'on veut créer un événement le 16 janvier à 9 h de 10 minutes intitulé "standup quotidien", il faudra rentrer :

Event.new("2019-01-13 09:00", 10, "standup quotidien")

Fais les changements adéquats dans le code de la classe Event et fais quelques tests depuis app.rb.
d) @attendees

Allez, on a presque fini : il veut maintenant pouvoir être capable d'enregistrer une liste (sous forme d'array) d’e-mails lors de la création de notre événement :

Event.new("2019-01-13 09:00", 10, "standup quotidien", ["truc@machin.com", "bidule@chose.fr"])

Fais les changements adéquats dans le code de la classe Event et fais quelques tests depuis app.rb pour confirmer que tout marche.
2.3.2. Décaler un événement

En faisant des interviews avec les utilisateurs de l'application, on s'est rendu compte qu'il était fréquent pour eux de décaler un événement à 24 heures plus tard. On veut donc que notre calendrier fasse ça de façon très simple : écris donc une méthode postpone_24h qui décale la start_date d'un évènement au lendemain, même heure.

Ainsi, si j'ai un évènement my_event, en faisant my_event.postpone_24h, je modifie sa @start_date de 24 h. Retourne plus haut voir comment faire ça avec les objets Time ou jette un œil à cette réponse sur StackOverflow.
2.3.3. Informations additionnelles sur l'évènement

Dans cette section, nous allons coder des méthodes qui te permettront d'obtenir des infos supplémentaires sur ton évènement (pas seulement ses attributs de base). Ainsi on voudrait pouvoir :

    Connaître la date de fin ;
    Savoir si un événement a déjà eu lieu (est-ce qu'il a commencé / est fini) ;
    Savoir si au contraire un événement est dans le futur ;
    Savoir si un événement est bientôt (dans moins de 30 minutes) ;

a) Date de fin

Avec la start_date et la duration, code une méthode intitulée end_date qui va calculer et te retourner l'heure de fin d'un événement si tu fais my_event.end_date.
b) A-t-il commencé ?

Créé une méthode is_past? pour savoir si un événement est passé ou pas. Si l'événement est dans le passé, en faisant my_event.is_past? on doit obtenir true. Sinon on obtient false.

Indice : Pour savoir si un évènement est passé, il suffit de comparer sa start_date avec la date et l'heure actuelle. Sache par ailleurs que tu peux comparer deux Time en faisant time_1 < time_2 qui va te retourner un booléen true/false en fonction de la réponse.
c) Est-il dans le futur ?

Code une méthode is_future? qui est l'inverse de is_past?.

Indice (il est en blanc sur blanc : surligne la phrase ci-après avec ta souris pour le révéler) : il y a deux façons de faire cette méthode "is_futur?". Soit tu la réécris comme "is_past?" en inverse la comparaison entre @start_time et l'heure actuelle, soit tu peux utiliser le fait qu'en Ruby, "!" permet d'obtenir le booléen inverse. Ainsi, le booléen inverse de my_event.is_past? est !my_event.is_past? . -fin de l'indice-
d) C'est bientôt ?

Une petite dernière méthode pour la route : ce serait bien de savoir si un événement est pour bientôt, c’est-à-dire si sa start_date est dans moins de 30 minutes. Code donc une méthode is_soon? en ce sens.
2.3.4. to_s

Maintenant que tu as plein de méthodes pour connaître plein de choses sur tes événements, nous allons coder une méthode pour afficher joliment un événement.
Pour le moment, si tu crées un my_event = Event.new(.....) et que tu fais puts my_event, ton terminal va afficher l'identifiant de l'objet du genre #<Event:0x00005600b4a9a3c0 @start_date="2019-03-26 12:18:40 +0100", blabla>. Nous on voudrait un affichage propre ressemblant à ça :

>Titre : RDV super important
>Date de début : 2010-10-31 12:00
>Durée : 30 minutes
>Invités : pierre@pierre.com, jean@jean.jean

Code la méthode to_s qui va afficher les détails de l'évènement, avec des puts, comme ci-dessus si tu fais my_event.to_s
📚 INSTANT CULTURE GÉ

Une méthode qui affiche de manière jolie un objet s'appelle en général to_s, car elle convertit le blob bizarre #<Event:0x00005600b4a9a3c0 @start_date="2019-03-26 12:18:40 +0100", blabla> en un string bien mis en page.
2.3.5. Méthode de classe User

Dernier exercice : dans la classe des utilisateurs, code une méthode find_by_email qui :

    Prend en entrée un e-mail (string)
    Donne en sortie un objet de type User dont le @email correspond à l'e-mail en entrée de la méthode

Voici ce que permettrait de faire cette méthode dans PRY :

#On crée 3 User
>User.new("julie@julie.com", 35)
>User.new("jean@jean.com", 23)
>User.new("claude@claude.com", 75)

#On cherche un des user à partir de son e-mail
>user_1 = User.find_by_email("claude@claude.com")

#On peut ensuite utiliser ce user comme on veut. Par exemple pour afficher son age:
>puts "Voici l'age du User trouvé : #{user_1.age}"

Indices (en blanc sur blanc : surligne la phrase ci-après avec ta souris pour le révéler) : une méthode de classe s'écrit en commençant par "def self.find_by_email(email)". Pour la coder, il faut qu'elle parcoure l'array de l'ensemble des utilisateurs "@@all_users" jusqu'à trouver celui dont l’e-mail correspond. -fin de l'indice-
3. Rendu attendu

Le repo avec les classes remplies.