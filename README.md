# super-app

A Flutter App for INTER IIT App Dev Team Selection PS.

<p float="left">
  <img src="https://github.com/ishashankmittal/Super-App/assets/117439240/9e6622f9-ab09-4afe-af77-05ccf8b10fad" width="300" />
  <img src="https://github.com/ishashankmittal/Super-App/assets/117439240/578a3ff5-b3ff-48d6-8b7a-b83c40b363c3" width="300" /> 
  <img src="https://github.com/ishashankmittal/Super-App/assets/117439240/e57acf67-6346-4800-a08b-ded16d058b53" width="300" />
</p>

Screen Recording Link: https://drive.google.com/file/d/1c-mrxv1hazLIybP35BzHLpmGo8hzBVQi/view?usp=sharing

Debug APK link: https://drive.google.com/file/d/1GNUKPh7SMWuToSSzzU5FlLrRmldjWe6j/view?usp=sharing

## Getting Started

first create a ```config.dart``` file in ```/lib``` and add your edamam Api key and applicaton id.

Then,

```flutter pub get```

```flutter run```

## Recipes (Food Tech)

Just enter the ingredients and we show the best recipe for you with Diet Labels!

I have created a Recipe Search feature where the user can enter the ingredient and gets a list of Recipes with images and Diet Labels.

For the API request i have used Edamam Recipe Search API .



## Plant Doctor (Agri Tech)

This feature employs a TensorFlow Lite classification model, trained on a diverse dataset of plant leaf images. This model helps to recognize and classify various plant diseases, providing users with disease class and a confidence score.

Fixed the issue of loading time on initial request by creating a dummy Post request as the user clicks on Plant Doctor Card and created a loading page for Plant Doctor.

Dataset used - PlantDoc Dataset for Disease Classification
https://github.com/pratikkayal/PlantDoc-Dataset

I have used Teachable Machine to train this model. First I downloaded the dataset and uploaded the train images in 28 classes and then trained and exported the .tflite file.

Now I wrote a flask Api to handle the ```/classify``` POST requests and hosted the flask app on render.com .
Link to the api : https://github.com/ishashankmittal/flaskApi



## BMI Calculator (Health Tech)

Calculate your Body Mass Index (BMI) instantly by entering your weight (kg) and height (feet and inches). The background color indicates your health status.

The user can input weight and height in kilograms and feet respectively. This feature calculates the BMI and then changes the background color indicating the health status of the user.


