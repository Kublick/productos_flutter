import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/product_service.dart';
import 'package:productos_app/widgets/product_image.dart';
import 'package:provider/provider.dart';
import '../ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
        create: (_) => ProductFormProvider(productService.selectedProduct),
        child: _ProductScreenBody(productService: productService));
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [
            Stack(children: [
              ProductImage(url: productService.selectedProduct.picture),
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
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image == null) {
                        return;
                      }
                      productService.updateSelectedProductImage(image.path);
                      print('Tenemos una imagen ${image.path}');
                    },
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: Colors.white)),
              ),
            ]),
            _ProductForm(),
            const SizedBox(height: 100),
          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (!productForm.isValidForm()) return;

            final String? imageUrl = await productService.uploadImage();
            print(imageUrl);
            await productService.saveOrCreateProduct(productForm.product);
          },
          child: const Icon(Icons.save_alt_outlined),
        ));
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: productForm.formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                    initialValue: product.name,
                    onChanged: (value) => product.name = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El Nombre es obligatorio';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre del Producto', labelText: "Nombre:")),
                const SizedBox(height: 30),
                TextFormField(
                    initialValue: '${product.price}',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        product.price = 0;
                      } else {
                        product.price = double.parse(value);
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: '\$ 150', labelText: "Precio:")),
                const SizedBox(height: 30),
                SwitchListTile(
                    value: product.available,
                    title: const Text('Disponible'),
                    activeColor: Colors.indigo,
                    onChanged: productForm.updateAvailability),
                const SizedBox(height: 30),
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)));
}
