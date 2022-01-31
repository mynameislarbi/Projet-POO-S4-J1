#On crée 3 User
julie = User.new("julie@julie.com", 35)
jean = User.new("jean@jean.com", 23)
claude = User.new("claude@claude.com", 75)

#On cherche un des user à partir de son e-mail
user_1 = User.find_by_email("julie@julie.com")

#On peut ensuite utiliser ce user comme on veut. Par exemple pour afficher son age:
puts "Voici l'age du User trouvé : #{user_1.age}"