// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('task_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar TEXT,
        createdAt INTEGER NOT NULL,
        lastActive INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        status TEXT NOT NULL,
        priority INTEGER NOT NULL,
        dueDate INTEGER,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        assignedTo TEXT,
        createdBy TEXT NOT NULL,
        category TEXT,
        attachments TEXT,
        completed INTEGER NOT NULL
      )
    ''');

  }



    // User CRUD operations
    Future<User> createUser(User user) async {
      final db = await instance.database;
      await db.insert('users', user.toMap());
      return user;
    }

    Future<User?> getUser(String id) async {
      final db = await instance.database;
      final maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      } else {
        return null;
      }
    }

    Future<User?> getUserByEmail(String email) async {
      final db = await instance.database;
      final maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      } else {
        return null;
      }
    }

    Future<int> updateUser(User user) async {
      final db = await instance.database;
      return await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }

    Future<int> deleteUser(String id) async {
      final db = await instance.database;
      return await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    // Task CRUD operations (1.5 points)
    Future<Task> createTask(Task task) async {
      final db = await instance.database;
      await db.insert('tasks', task.toMap());
      return task;
    }

    Future<Task?> getTask(String id) async {
      final db = await instance.database;
      final maps = await db.query(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Task.fromMap(maps.first);
      } else {
        return null;
      }
    }

    Future<List<Task>> getAllTasks() async {
      final db = await instance.database;
      final result = await db.query('tasks');
      return result.map((json) => Task.fromMap(json)).toList();
    }

    Future<List<Task>> getTasksByUser(String userId) async {
      final db = await instance.database;
      final result = await db.query(
        'tasks',
        where: 'createdBy = ? OR assignedTo = ?',
        whereArgs: [userId, userId],
      );
      return result.map((json) => Task.fromMap(json)).toList();
    }

    Future<int> updateTask(Task task) async {
      final db = await instance.database;
      return await db.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    }

    Future<int> deleteTask(String id) async {
      final db = await instance.database;
      return await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    // Search and filter methods (0.5 point)
    Future<List<Task>> searchTasks(String query) async {
      final db = await instance.database;
      final result = await db.query(
        'tasks',
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
      return result.map((json) => Task.fromMap(json)).toList();
    }

    Future<List<Task>> filterTasks({
      String? status,
      int? priority,
      String? category,
      bool? completed,
    }) async {
      final db = await instance.database;
      final where = <String>[];
      final whereArgs = <dynamic>[];

      if (status != null) {
        where.add('status = ?');
        whereArgs.add(status);
      }

      if (priority != null) {
        where.add('priority = ?');
        whereArgs.add(priority);
      }

      if (category != null) {
        where.add('category = ?');
        whereArgs.add(category);
      }

      if (completed != null) {
        where.add('completed = ?');
        whereArgs.add(completed ? 1 : 0);
      }

      final whereClause = where.isNotEmpty ? where.join(' AND ') : null;
      final result = await db.query(
        'tasks',
        where: whereClause,
        whereArgs: whereArgs,
      );

      return result.map((json) => Task.fromMap(json)).toList();
    }

    // Close database
    Future close() async {
      final db = await instance.database;
      db.close();
    }
}


