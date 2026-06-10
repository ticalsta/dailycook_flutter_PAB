import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'detail_screen.dart';
import 'add_recipe_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  TextEditingController searchC = TextEditingController();

  List recipes = [
    {
      "title": "Nasi Goreng",
      "subtitle": "10 menit • Hemat",
      "emoji": "🍜",
      "category": "Hemat",
      "ingredients":
          "• Nasi\n"
          "• Telur\n"
          "• Bawang merah\n"
          "• Kecap manis\n"
          "• Cabai",
      "steps":
          "1. Panaskan minyak\n"
          "2. Tumis bawang dan cabai\n"
          "3. Masukkan telur\n"
          "4. Tambahkan nasi\n"
          "5. Beri kecap lalu aduk rata",
    },
    {
      "title": "Sup Ayam",
      "subtitle": "Sehat • Keluarga",
      "emoji": "🍲",
      "category": "Sehat",
      "ingredients":
          "• Ayam\n"
          "• Wortel\n"
          "• Kentang\n"
          "• Daun bawang\n"
          "• Bawang putih",
      "steps":
          "1. Rebus ayam\n"
          "2. Masukkan sayur\n"
          "3. Tambahkan bumbu\n"
          "4. Masak hingga matang",
    },
    {
      "title": "Mie Pedas",
      "subtitle": "Praktis Anak Kos",
      "emoji": "🍝",
      "category": "Cepat",
      "ingredients":
          "• Mie\n"
          "• Cabai\n"
          "• Telur\n"
          "• Sosis",
      "steps":
          "1. Rebus mie\n"
          "2. Tumis cabai\n"
          "3. Masukkan telur\n"
          "4. Campurkan mie",
    },
    {
      "title": "Salad Buah",
      "subtitle": "Fresh & Sehat",
      "emoji": "🥗",
      "category": "Dessert",
      "ingredients":
          "• Apel\n"
          "• Melon\n"
          "• Anggur\n"
          "• Yogurt",
      "steps":
          "1. Potong buah\n"
          "2. Tambahkan yogurt\n"
          "3. Sajikan dingin",
    },
  ];

  List filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    filteredRecipes = recipes;
  }

  void filterRecipe(String keyword) {
    setState(() {
      if (keyword == "Semua") {
        filteredRecipes = recipes;
      } else {
        filteredRecipes = recipes.where((recipe) {
          return recipe["category"] == keyword;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF8F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, Tika 👋",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Mau masak apa hari ini?",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.orange.shade200,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, blurRadius: 10),
                  ],
                ),
                child: TextField(
                  controller: searchC,
                  onChanged: (value) {
                    setState(() {
                      filteredRecipes = recipes.where((recipe) {
                        return recipe["title"]
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Cari resep favoritmu...",
                    icon: Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Kategori",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    categoryItem(
                      "Semua",
                      const Color.fromARGB(255, 133, 130, 130),
                    ),
                    categoryItem("Hemat", Colors.orange),
                    categoryItem("Cepat", Colors.green),
                    categoryItem("Sehat", Colors.red),
                    categoryItem("Dessert", Colors.purple),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Resep Populer",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: filteredRecipes.map((recipe) {
                    return recipeCard(context, recipe);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
          );

          if (result != null) {
            setState(() {
              recipes.add({
                "title": result["title"],
                "subtitle": result["category"],
                "emoji": "🍽️",
                "category": result["category"],
                "ingredients": result["ingredients"],
                "steps": result["steps"],
              });

              filteredRecipes = List.from(recipes);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget categoryItem(String title, Color color) {
    return GestureDetector(
      onTap: () {
        filterRecipe(title);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget recipeCard(BuildContext context, Map recipe) {
    String title = recipe["title"] ?? "";
    String subtitle = recipe["subtitle"] ?? "";
    String emoji = recipe["emoji"] ?? "🍽️";
    String ingredients = recipe["ingredients"] ?? "";
    String steps = recipe["steps"] ?? "";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(
              title: title,
              subtitle: subtitle,
              emoji: emoji,
              ingredients: ingredients,
              steps: steps,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 40)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            emoji == "🍽️"
                ? Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddRecipeScreen(recipe: recipe),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              recipe["title"] = result["title"];
                              recipe["subtitle"] = result["category"];
                              recipe["category"] = result["category"];
                              recipe["ingredients"] = result["ingredients"];
                              recipe["steps"] = result["steps"];

                              filteredRecipes = List.from(recipes);
                            });
                          }
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Hapus Resep"),
                              content: const Text(
                                "Yakin ingin menghapus resep ini?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      recipes.removeWhere(
                                        (item) => item == recipe,
                                      );
                                      filteredRecipes = List.from(recipes);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Resep berhasil dihapus"),
                                      ),
                                    );
                                  },
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
