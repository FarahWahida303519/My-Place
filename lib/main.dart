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
              SizedBox(height: 10),

              if (isLoading)
                CircularProgressIndicator(), //loading progress will be run when system run and retrieve a data
              //ERROR
              if (!isLoading && errorMessage.isNotEmpty)
                Column(
                  children: [
                    Text(
                      errorMessage, //ERROR MESSAGE TO ALERT USER!
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),

                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: loadPlaces, //calling method  loadPlaces
                      child: Text("Retry"),
                    ),
                  ],
                ),

              // NO DATA UI
              if (!isLoading && errorMessage.isEmpty && places.isEmpty)
                Text(
                  "No data available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

              //Display Data when data exixts
              if (!isLoading && errorMessage.isEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: places .length, //it will total num of item when to display based on api data
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
                          boxShadow: [
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
                            ClipRRect(// display the image inside dialog with rounded
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                p.imageUrl, //display image from api data
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) { //if the image fail to load, the function will show the broken image icon
                                  return Icon(Icons.broken_image, size: 80);
                                },
                              ),
                            ),

                            // CONTENT
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name, //display name from api data
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),
                                  Text(
                                    p.state, //display state from api data
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),

                                  SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // RATING BOX
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow.shade700,
                                          borderRadius: BorderRadius.circular( 6, ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(p.rating.toStringAsFixed(1)),
                                            
                                             SizedBox(width: 6),
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
                                                backgroundColor: Color.fromARGB( 255, 253,245,247,),
                                                title: Text(
                                                  p.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                          child: Image.network(
                                                            p.imageUrl,height: 200,width: 260, fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text("ID : ${p.id}"),
                                                      Text(
                                                        "Category : ${p.category}",
                                                      ),
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
                                                      Text(
                                                        "Description:",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        p.description.isEmpty? "-": p.description,
                                                      ),

                                                      SizedBox(height: 10),
                                                      Text(
                                                        "Contact:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        p.contact.isEmpty? "-" : p.contact,),

                                                      SizedBox(height: 10),
                                                      Text(
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
                                                    child: Text("Close"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child:  Text("View Detail"),
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
    // Start loading
    setState(() {
      isLoading = true;
      errorMessage = "";
      places = [];
    });

    try {
      // Prepare URL
      Uri url = Uri.parse(
        "https://slumberjer.com/teaching/a251/locations.php?state=&category=&name=",
      );

      // GET request with timeout
      var response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              // If the API takes too long
              errorMessage = "Connection Timeout. Please try again.";

              setState(() {
                isLoading = false;
              });

              return http.Response("Timeout", 408);
            },
          );

      // If the server returns an error
      if (response.statusCode != 200) {
        errorMessage =
            "Server Error: ${response.statusCode}. Unable to connect. Please check your internet connection.";

        setState(() {
          isLoading = false;
        });

        return;
      }

      // Decode JSON response
      var decoded = json.decode(response.body);

      if (decoded is List) {
        // Prevent duplicate data
        places = [];

        for (int i = 0; i < decoded.length; i++) {
          var element = decoded[i];
          Place place = Place.fromJson(element);
          places.add(place);
        }

        if (places.isEmpty) {
          errorMessage = "No data found.";
        }
      } else {
        // Invalid format
        errorMessage = "Invalid data format.";
      }
    } catch (e) {
      // Generic connection or API failure
      errorMessage =
          "Unable to connect. Please check your internet connection.";
    }
    // Finish loading
    setState(() {
      isLoading = false;
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
