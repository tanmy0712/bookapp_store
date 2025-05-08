import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../data/models/author_model.dart';
import '../../../data/models/book_model.dart';
import '../../../data/models/category_model.dart';
import '../../utils/popups/loaders.dart';

class AdminBookRepository extends GetxController {
  static AdminBookRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Fetch All Books (Admin Only)
  Future<List<BookModel>> getAllBooks() async {
    try {
      final snapshot = await _db.collection('books').get();
      List<BookModel> books = [];

      for (var doc in snapshot.docs) {
        BookModel book = BookModel.fromSnapshot(doc);

        // Fetch author and category details
        final authorSnapshot =
            await _db.collection('authors').doc(doc['authorId']).get();
        final categorySnapshot =
            await _db.collection('categories').doc(doc['categoryId']).get();

        if (authorSnapshot.exists && categorySnapshot.exists) {
          book = BookModel(
            id: book.id,
            title: book.title,
            description: book.description,
            isbn: book.isbn,
            price: book.price,
            stock: book.stock,
            author: AuthorModel.fromSnapshot(authorSnapshot),
            category: CategoryModel.fromSnapshot(categorySnapshot),
            imageUrls: book.imageUrls,
            publishedDate: book.publishedDate,
            publisher: book.publisher,
            language: book.language,
            pages: book.pages,
            rating: book.rating,
            reviewsCount: book.reviewsCount,
            createdAt: book.createdAt,
            isFeatured: book.isFeatured,
          );
        }

        books.add(book);
      }

      return books;
    } catch (e) {
      throw 'Error fetching all books: ${e.toString()}';
    }
  }

  // Create Book (Admin Only)
  // Create Book (Admin Only)
  Future<void> createBook(BookModel book) async {
    try {
      final storage = FirebaseStorage.instance;
      WriteBatch batch = _db.batch();

      final List<String> imageUrls = [];

      for (String imagePath in book.imageUrls) {
        String imageUrl = imagePath;
        if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
          try {
            final path = 'book-images/${DateTime.now().millisecondsSinceEpoch}.png';
            final fileBytes = await XFile(imagePath).readAsBytes();
            final ref = storage.ref().child(path);
            await ref.putData(fileBytes);
            imageUrl = await ref.getDownloadURL();
          } catch (e) {
            if (kDebugMode) {
              print('Error uploading image for ${book.title}: $e');
            }
          }
        }
        imageUrls.add(imageUrl);
      }

      final updatedBook = book.toJson()..['imageUrls'] = imageUrls;
      final docRef = _db.collection('books').doc(); // auto-gen ID
      batch.set(docRef, updatedBook);

      await batch.commit();

      LLoaders.successSnackBar(
        title: 'Success',
        message: 'Book created successfully',
      );
    } catch (e) {
      throw 'Error creating book: ${e.toString()}';
    }
  }

  // Update Book (Admin Only)
  Future<void> updateBook(BookModel book) async {
    try {
      final storage = FirebaseStorage.instance;
      WriteBatch batch = _db.batch();

      final List<String> imageUrls = [];

      for (String imagePath in book.imageUrls) {
        String imageUrl = imagePath;
        if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
          try {
            final path = 'book-images/${DateTime.now().millisecondsSinceEpoch}.png';
            final fileBytes = await XFile(imagePath).readAsBytes();
            final ref = storage.ref().child(path);
            await ref.putData(fileBytes);
            imageUrl = await ref.getDownloadURL();
          } catch (e) {
            if (kDebugMode) {
              print('Error uploading image for ${book.title}: $e');
            }
          }
        }
        imageUrls.add(imageUrl);
      }

      final updatedBook = book.toJson()..['imageUrls'] = imageUrls;
      final docRef = _db.collection('books').doc(book.id);
      batch.update(docRef, updatedBook);

      await batch.commit();
      LLoaders.successSnackBar(
        title: 'Success',
        message: 'Book updated successfully',
      );
    } catch (e) {
      throw 'Error updating book: ${e.toString()}';
    }
  }

  // Delete Book (Admin Only) and remove from all user wishlists
  Future<void> deleteBook(String bookId) async {
    try {
      // Delete the book document
      await _db.collection('books').doc(bookId).delete();

      // For each user, remove any wishlist document where the bookId matches
      final usersSnapshot = await _db.collection('users').get();
      for (var userDoc in usersSnapshot.docs) {
        final wishlistSnapshot =
            await _db
                .collection('users')
                .doc(userDoc.id)
                .collection('wishlist')
                .where('bookId', isEqualTo: bookId)
                .get();
        for (var wishlistDoc in wishlistSnapshot.docs) {
          await wishlistDoc.reference.delete();
        }
      }
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }
}
