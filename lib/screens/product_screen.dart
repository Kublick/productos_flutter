import 'package:flutter/material.dart';
import 'package:productos_app/widgets/product_image.dart';
import '../ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [
            Stack(children: [
              const ProductImage(),
              Positioned(
                top: 60,
                left: 20,
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white)),
              ),
              Positioned(
                top: 60,
                right: 20,
                child: IconButton(
                    onPressed: () => {
                          //TODO Galeria
                        },
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: Colors.white)),
              ),
            ]),
            const _ProductForm(),
            const SizedBox(height: 100),
          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.save_alt_outlined),
        ));
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            child: Column(
          children: [
            const SizedBox(height: 10),
            TextFormField(
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del Producto', labelText: "Nombre:")),
            const SizedBox(height: 30),
            TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '\$ 150', labelText: "Precio:")),
            const SizedBox(height: 30),
            SwitchListTile(
                value: true,
                title: const Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: (value) => {
                      //TODO Pendiente
                    }),
            const SizedBox(height: 30),
          ],
        )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)));
}
