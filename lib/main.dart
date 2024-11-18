import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(DelishDiscoveryApp());

class DelishDiscoveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delish Discovery',
      theme: ThemeData(
        primaryColor: Color(0xFFF08080),
        hintColor: Color(0xFFF4978E),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecipeHomePage(),
    );
  }
}

class RecipeHomePage extends StatefulWidget {
  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  final TextEditingController _ingredientController = TextEditingController();
  List<dynamic> _recipes = [];

  Future<void> _fetchRecipes(String ingredient) async {
    final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?i=$ingredient');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _recipes = data['meals'] ?? [];
        });
      } else {
        setState(() {
          _recipes = [];
        });
      }
    } catch (e) {
      setState(() {
        _recipes = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delish Discovery'),
        backgroundColor: Color(0xFFF08080),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                labelText: 'Enter an ingredient',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF8AD9D).withOpacity(0.8),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF4978E),
              ),
              onPressed: () {
                if (_ingredientController.text.isNotEmpty) {
                  _fetchRecipes(_ingredientController.text);
                }
              },
              child: Text('Suggest Dishes'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _recipes.isEmpty
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFFBC4AB).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'No recipes found.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _recipes[index];
                        return Card(
                          color: Color(0xFFFBC4AB).withOpacity(0.8),
                          child: ListTile(
                            title: Text(
                              recipe['strMeal'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 240, 238, 238)),
                            ),
                            leading: Image.network(
                              recipe['strMealThumb'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
