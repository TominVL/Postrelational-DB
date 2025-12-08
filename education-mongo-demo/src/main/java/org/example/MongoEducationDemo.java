package org.example;

import com.mongodb.client.*;
import com.mongodb.client.model.*;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.util.Arrays;
import java.util.List;

public class MongoEducationDemo {

    // якщо в тебе MongoDB без паролю, рядок такий:
    private static final String CONNECTION_STRING = "mongodb://localhost:27017";
    private static final String DATABASE_NAME = "education_db";

    public static void main(String[] args) {
        try (MongoClient mongoClient = MongoClients.create(CONNECTION_STRING)) {
            MongoDatabase database = mongoClient.getDatabase(DATABASE_NAME);

            System.out.println("╔══════════════════════════════════════════════════════════════╗");
            System.out.println("║           EDUCATION DB - MongoDB Demo                        ║");
            System.out.println("╚══════════════════════════════════════════════════════════════╝");

            printAllCollections(database);
            performKeyValueQueries(database);
            performAggregation(database);

        } catch (Exception e) {
            System.err.println("Error connecting to MongoDB: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 1. Вивід усіх документів
    private static void printAllCollections(MongoDatabase database) {
        System.out.println("\n");
        System.out.println("════════════════════════════════════════════════════════════════");
        System.out.println("              1. ALL DOCUMENTS IN COLLECTIONS                   ");
        System.out.println("════════════════════════════════════════════════════════════════");

        String[] collections = {"students", "teachers", "schools", "courses", "lessons"};

        for (String collectionName : collections) {
            printCollection(database, collectionName);
        }
    }

    private static void printCollection(MongoDatabase database, String collectionName) {
        MongoCollection<Document> collection = database.getCollection(collectionName);

        System.out.println("\n┌─────────────────────────────────────────────────────────────┐");
        System.out.println("│ Collection: " + collectionName.toUpperCase());
        System.out.println("├─────────────────────────────────────────────────────────────┤");

        long count = 0;
        for (Document doc : collection.find()) {
            System.out.println("  " + doc.toJson());
            count++;
        }

        System.out.println("├─────────────────────────────────────────────────────────────┤");
        System.out.println("│ Total documents: " + count);
        System.out.println("└─────────────────────────────────────────────────────────────┘");
    }

    // 2. Key-value запити
    private static void performKeyValueQueries(MongoDatabase database) {
        System.out.println("\n");
        System.out.println("════════════════════════════════════════════════════════════════");
        System.out.println("              2. KEY-VALUE QUERIES (2+ CONDITIONS)              ");
        System.out.println("════════════════════════════════════════════════════════════════");

        // Query 1: студенти на курсі MongoDB з оператором Kyivstar
        System.out.println("\n┌─────────────────────────────────────────────────────────────┐");
        System.out.println("│ Query 1: Students on MongoDB course with Kyivstar operator  │");
        System.out.println("├─────────────────────────────────────────────────────────────┤");

        MongoCollection<Document> students = database.getCollection("students");
        Bson q1 = Filters.and(
                Filters.eq("courseIds", "course_mongodb"),
                Filters.eq("phone.operator", "Kyivstar")
        );

        for (Document doc : students.find(q1)) {
            Document phone = (Document) doc.get("phone");
            System.out.println("  Name: " + doc.getString("fullName")
                    + ", Email: " + doc.getString("email")
                    + ", Operator: " + (phone != null ? phone.getString("operator") : "N/A"));
        }
        System.out.println("└─────────────────────────────────────────────────────────────┘");

        // Query 2: лекції по курсу MongoDB
        System.out.println("\n┌─────────────────────────────────────────────────────────────┐");
        System.out.println("│ Query 2: Lectures for course 'MongoDB Basics'               │");
        System.out.println("├─────────────────────────────────────────────────────────────┤");

        MongoCollection<Document> lessons = database.getCollection("lessons");
        Bson q2 = Filters.and(
                Filters.eq("courseId", "course_mongodb"),
                Filters.eq("content.type", "lecture")
        );

        for (Document doc : lessons.find(q2)) {
            Document content = (Document) doc.get("content");
            System.out.println("  Lesson: " + content.getString("title")
                    + ", Notes: " + content.getString("notes"));
        }
        System.out.println("└─────────────────────────────────────────────────────────────┘");
    }

    // 3. Агрегація
    private static void performAggregation(MongoDatabase database) {
        System.out.println("\n");
        System.out.println("════════════════════════════════════════════════════════════════");
        System.out.println("        3. AGGREGATION (4+ STAGES WITH $lookup AND $group)      ");
        System.out.println("════════════════════════════════════════════════════════════════");

        MongoCollection<Document> courses = database.getCollection("courses");

        System.out.println("\n┌─────────────────────────────────────────────────────────────┐");
        System.out.println("│ Aggregation: Number of lessons per course                   │");
        System.out.println("│ Stages: $lookup → $unwind → $group → $sort                  │");
        System.out.println("├─────────────────────────────────────────────────────────────┤");

        List<Bson> pipeline = Arrays.asList(
                Aggregates.lookup("lessons", "_id", "courseId", "lessons"),
                Aggregates.unwind("$lessons"),
                Aggregates.group("$title",
                        Accumulators.sum("lessonCount", 1),
                        Accumulators.addToSet("types", "$lessons.content.type")),
                Aggregates.sort(Sorts.descending("lessonCount"))
        );

        for (Document doc : courses.aggregate(pipeline)) {
            String courseTitle = doc.getString("_id");
            Integer count = doc.getInteger("lessonCount");
            List<String> types = (List<String>) doc.get("types");

            System.out.println("\n  📘 Course: " + courseTitle);
            System.out.println("     Lessons total: " + count);
            System.out.println("     Types: " + types);
        }

        System.out.println("\n└─────────────────────────────────────────────────────────────┘");
        System.out.println("\n╔══════════════════════════════════════════════════════════════╗");
        System.out.println("║                    Demo Complete!                            ║");
        System.out.println("╚══════════════════════════════════════════════════════════════╝");
    }
}
