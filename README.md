# SenateAttendanceTracker

## Run the App Locally

### Initial Setup

Clone the project

In the config folder, you will need to make a database.yml file so rails knows what database to use/create. If you don't know how to do that,
you can find the information here: https://edgeguides.rubyonrails.org/configuring.html#configuring-a-database

In an Ubuntu enviornment (we used WSL2), run the following:

- bundle install
- yarn install
  
- rake db:setup
  
- rake db:migrate
  
- rake db:seed

### Run the App
Running rails s and going to localhost:3000 in your browser, you should see the application


## Deploying to Heroku

- make an app in heroku
- in your terminal, push the code to your heroku app repository (detailed instructions here https://devcenter.heroku.com/articles/git)
- in the heroku terminal (either CLI or online commandline), run rake db:setup followed by rake db:seed
- the heroku website should now function

## CI/CD

By default, upon making a pull request, Rspec and Rubocop will run. If it fails either of those, it will let you know in the pull request.
Additionally, if you want the app to be pushed to a heroku app upon being merged into main, edit the main action (in main.yml). You can see the options for which heroku app it will deploy to, you simply have to edit the file to point to your app.

