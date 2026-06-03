import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  TextEditingController titleC = TextEditingController();

  TextEditingController subtitleC = TextEditingController();

  TextEditingController ingredientsC = TextEditingController();

  TextEditingController stepsC = TextEditingController();

  Future addRecipe() async {
    var url = Uri.parse("http://192.168.1.83/dailycook_api/add_recipe.php");

    var response = await http.post(
      url,

      body: {
        "title": titleC.text,
        "subtitle": subtitleC.text,
        "ingredients": ingredientsC.text,
        "steps": stepsC.text,
      },
    );

    var data = jsonDecode(response.body);

    if (data["status"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resep berhasil ditambahkan")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal tambah resep")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Tambah Resep"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [
              textField("Nama Resep", titleC),

              const SizedBox(height: 20),

              textField("Bahan-Bahan", ingredientsC),

              const SizedBox(height: 20),

              textField("Cara Memasak", stepsC),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),

                  onPressed: () {
                    addRecipe();
                  },

                  child: Text(
                    "Simpan",

                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,

      maxLines: hint == "Bahan-Bahan" || hint == "Cara Memasak" ? 5 : 1,

      decoration: InputDecoration(
        hintText: hint,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
