# hotelcovid19_app

A Flutter project that provides an app that allows registered patients in [HotelCovid19](https://github.com/jahs-es/hotelcovid19) to provide, edit and delete 
measures that show his health status at every time. That measure are sent to be monitorized by an admin.   

## Technical aspects

Solution is done using bloc for state management. External data comes from a backend accessed using API Rest.

Test using flutter_test and bloc_test.

CI/CD workflow using GitHub Actions. 

Security use JWT token to access secured endpoints. 

## Backend configuration 

In order to connect to backend service you must set `host` var in `api_path.dart` file. 


 
