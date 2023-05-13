# API-YelpLike


Le but est de faire une application similaire à Yelp, mais en plus simple. Avec une base de données gérer par une API. On pourra accéder aux restaurents qui sont dans la base de données. On pourra aussi ajouter des restaurants, et les modifier. Mettre des commentaires avec des photos. Mettre des restaurants dans les favories.


## - API

L'API et la BDD est fait avec Firebase.

![schema bdd](https://media.discordapp.net/attachments/1077217191918850148/1092479823135387749/Screenshot_2023-04-03_at_18.04.15.png?width=1914&height=1132)

## - Application

Elle sera faite en Swift avec UIKit. Elle sera faite pour IOS 14.0 et supérieur. Elle sera faite avec une architecture MVVM.


## Installation

### Firebase

Créez un projet sur Firebase, suivez toutes les instructions qu'ils donnent par rapport à une application iOS. Téléchargez le fichier `GoogleService-Info.plist` et mettez le dans votre projet avec le fichier `info.plist`. Créez une base de données Firestore, créez à l'intérieur les colletions suivantes : `Users`, `Review`, `Restaurant`, `Favorites`.

### Application

Ouvrez le projet avec XCode, allez dans la configuration de la Target `YelpLike` et changez dans la section `Signing & Capabilities` votre `Team` et votre `Bundle Identifier`.

Vous n'avez plus qu'à lancer l'application 😊
