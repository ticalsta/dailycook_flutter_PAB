import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddRecipeScreen extends StatefulWidget {
  final Map? recipe;

  const AddRecipeScreen({super.key, this.recipe});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final titleC = TextEditingController();
  final categoryC = TextEditingController();
  final ingredientsC = TextEditingController();
  final stepsC = TextEditingController();
  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      isEdit = true;
      titleC.text = widget.recipe!["title"] ?? "";
      categoryC.text = widget.recipe!["category"] ?? "";
      ingredientsC.text = widget.recipe!["ingredients"] ?? "";
      stepsC.text = widget.recipe!["steps"] ?? "";
    }
  }

  Future<void> saveRecipe() async {
    if (titleC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama resep wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      var url = isEdit
          ? Uri.parse("http://192.168.1.67/dailycook_api/edit_recipe.php")
          : Uri.parse("http://192.168.1.67/dailycook_api/add_recipe.php");

      Map<String, String> bodyData = {
        "title": titleC.text,
        "category": categoryC.text,
        "ingredients": ingredientsC.text,
        "steps": stepsC.text,
      };

      if (isEdit && widget.recipe!["id"] != null) {
        bodyData["id"] = widget.recipe!["id"].toString();
      }

      // Debug
      print("isEdit: $isEdit");
      print("ID dikirim: ${bodyData['id']}");
      print("Semua data: $bodyData");

      var response = await http.post(url, body: bodyData);

      String responseBody = response.body;
      int jsonStart = responseBody.indexOf('{');
      if (jsonStart == -1) {
        throw Exception("Response tidak valid: $responseBody");
      }
      responseBody = responseBody.substring(jsonStart);

      var data = jsonDecode(responseBody);

      if (data["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit ? "Resep berhasil diperbarui" : "Resep berhasil ditambahkan",
            ),
          ),
        );
        Navigator.pop(context, {
          "id": isEdit ? widget.recipe!["id"] : data["id"],
          "title": titleC.text,
          "category": categoryC.text,
          "ingredients": ingredientsC.text,
          "steps": stepsC.text,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Gagal menyimpan resep")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(isEdit ? "Edit Resep" : "Tambah Resep"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              textField("Nama Resep", titleC),
              const SizedBox(height: 16),
              textField("Kategori", categoryC),
              const SizedBox(height: 16),
              textField("Bahan-Bahan", ingredientsC, maxLines: 5),
              const SizedBox(height: 16),
              textField("Cara Memasak", stepsC, maxLines: 5),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: isLoading ? null : saveRecipe,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEdit ? "Perbarui" : "Simpan",
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

  Widget textField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}