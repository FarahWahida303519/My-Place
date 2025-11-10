// -------------------- IMPORTS --------------------
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'place.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: MyPlaceScreen()),
  );
}

class MyPlaceScreen extends StatefulWidget {
  const MyPlaceScreen({super.key});

  @override
  State<MyPlaceScreen> createState() => _MyPlaceScreenState();
}

class _MyPlaceScreenState extends State<MyPlaceScreen> {
  List<Place> places = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 550) width = 550;

    return Scaffold(
      backgroundColor: Color(0xFFFDECEF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7DDE6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "🌺 Discover Malaysia 🌺",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: width,
          child: Column(
            children: [
              const SizedBox(height: 10),
              if (isLoading)
                CircularProgressIndicator(), //loading progress will be run when system run and retrieve a data
              if (!isLoading && errorMessage.isNotEmpty)
                Column(
                  children: [
                    Text(
                      errorMessage, //ERROR MESSAGE TO ALERT USER!
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: loadPlaces, //calling method  loadPlaces
                      child: const Text("Retry"),
                    ),
                  ],
                ),

              if (!isLoading && errorMessage.isEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: places
                        .length, //it will total num of item when to display based on api data
                    itemBuilder: (context, index) {
                      final p =
                          places[index]; //p hold data like name,image,rating,contact basedd on api

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // IMAGE
                            ClipRRect(
                              //I use ClipRRect because i want to display the image inside dialog with rounded
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                p.imageUrl, //display image from api data
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  //if the image fail to load, the function will show the broken image icon
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 80,
                                  );
                                },
                              ),
                            ),

                            // CONTENT
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name, //display name from api data
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),
                                  Text(
                                    p.state, //display state from api data
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [

                                      
                                      // RATING BOX
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow.shade700,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(p.rating.toStringAsFixed(1)),
                                            const SizedBox(width: 6),
                                            Text(ratingLabel(p.rating)),
                                          ],
                                        ),
                                      ),


                                      // ShowDialog
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Color.fromARGB(255, 253, 245, 247),
                                                title: Text(
                                                  p.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment .start,
                                                    children: [
                                                      Center(
                                                        child: ClipRRect(
                                                          borderRadius:BorderRadius.circular( 15,),
                                                          child: Image.network(
                                                            p.imageUrl,
                                                            height: 200,
                                                            width: 260,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text("ID : ${p.id}"),
                                                      Text("State: ${p.state}"),
                                                      Text(
                                                        "Category: ${p.category}",
                                                      ),
                                                      Text(
                                                        "Rating: ${p.rating} (${ratingLabel(p.rating)})",
                                                      ),

                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Text(
                                                        "Description:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        p.description.isEmpty
                                                            ? "-"
                                                            : p.description,
                                                      ),

                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Text(
                                                        "Contact:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        p.contact.isEmpty
                                                            ? "-"
                                                            : p.contact,
                                                      ),

                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Text(
                                                        "Location:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Lat: ${p.latitude}, Lng: ${p.longitude}",
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Close"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text("View Detail"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Reuest API
  Future<void> loadPlaces() async {
    setState(() {
      //refresh ui
      isLoading = true; //display the loading indicator
      errorMessage = ""; //clear error mesg
      places = []; //empty list before loading new data
    });

    try {
      //send GET request to Api and wait for response
      var response = await http
          .get(
            Uri.parse(
              "https://slumberjer.com/teaching/a251/locations.php?state=&category=&name=",
            ),
          )
          .timeout(
            const Duration(seconds: 10), //wait 10 sec
            onTimeout: () {
              //to handle if api timeout
              errorMessage = "Connection Timeout.";
              setState(() {
                isLoading = false;
              }); // stop loading spinner
              return http.Response("Error", 408); // return timeout response
            },
          );

      if (response.statusCode != 200) {
        //if error happen
        errorMessage = "Server Error: ${response.statusCode}"; //set error mes
        // refresh ui
        setState(() {
          isLoading = false; // stop loading spinner
        });

        return; // exit the function
      }

      var decoded = json.decode(response.body); //convert json into dart

      if (decoded is List) {
        places = []; //avoid duplicate data api
        for (var element in decoded) {
          //loop through json obj inside decode list
          Place place = Place.fromJson(
            element,
          ); //convert json obj into place obj
          places.add(place);
        } //adding
      } else {
        errorMessage =
            "Invalid data format."; //error msg display when api not return list
      }
    } on SocketException {
      //handle error no internet connection
      errorMessage = "No internet connection.";
    } catch (e) {
      //catch any errorhappen
      errorMessage = "Error: $e";
    }

    setState(() {
      //after finish loading,update ui
      isLoading = false; // stop spinner after finishing
    });
  }

  String ratingLabel(double r) {
    //method convert num into label
    if (r >= 4.5) return "Excellent";
    if (r >= 4.0) return "Very Good";
    if (r >= 3.0) return "Average";
    return "Low";
  }
}
