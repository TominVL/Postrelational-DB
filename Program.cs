using System;
using System.Collections.Generic;
using System.Linq;

// 1) Абстрактний клас + публічні/приватні властивості та методи
abstract class Person
{
    public Guid Id { get; } = Guid.NewGuid();
    public string Name { get; protected set; }    
    private DateTime _createdAt = DateTime.UtcNow; // приватне поле

    public DateTime CreatedAtUtc => _createdAt;

    // абстрактний метод (поліморфізм)
    public abstract string Describe();

    // перевантажені методи (overload)
    public void Rename(string newName) => Name = newName;
    public void Rename(string prefix, string newName) => Name = $"{prefix}{newName}";
}

// 2) Наслідування від абстрактного класу
class Teacher : Person
{
    public string Subject { get; private set; } 

    public Teacher(string name, string subject)
    {
        Name = name; Subject = subject;
    }

    public override string Describe() => $"Teacher {Name} — {Subject}";
}

class Student : Person
{
    // посилання на інший об’єкт (викладач як наставник)
    public Teacher Advisor { get; private set; }

    public List<int> Grades { get; } = new();

    public Student(string name) { Name = name; }

    public void SetAdvisor(Teacher t) => Advisor = t;

    // перевантаження: додавання однієї оцінки або кількох
    public void AddGrade(int g) => Grades.Add(g);
    public void AddGrade(params int[] many) { Grades.AddRange(many); }

    // приватний хелпер
    private double Avg() => Grades.Count == 0 ? double.NaN : Grades.Average();

    public override string Describe()
        => $"Student {Name} — advisor: {Advisor?.Name ?? "(none)"}, grades: {Grades.Count}, avg: {Avg():F1}";
}

// 3) Клас-композиція: має список об’єктів базового типу (масив/список об’єктів)
class Classroom
{
    public string Code { get; }
    private readonly List<Person> _people = new(); // приватне поле

    public IReadOnlyList<Person> People => _people; // публічна “властивість-читання”

    public Classroom(string code) { Code = code; }

    // перевантаження: додати особу
    public void Add(Person p) => _people.Add(p);
    public void Add(params Person[] many) => _people.AddRange(many);

    public override string ToString() => $"Classroom {Code} — {_people.Count} people";
}

class Program
{
    static void Main()
    {
        // створення об’єктів усіх класів
        var t = new Teacher("Dr. Ada", "Algorithms");
        var s = new Student("Vlad");
        var room = new Classroom("CS-101");

        // заповнення властивостей і виклики методів
        s.SetAdvisor(t);
        s.AddGrade(90);                // overload #1
        s.AddGrade(88, 95, 100);       // overload #2 (params)

        t.Rename("Prof. ", "Ada");     // перевантажений метод із префіксом
        s.Rename("Vladyslav");         // перевантажений метод без префікса

        room.Add(t, s);                // overload додавання кількох

        // поліморфний виклик Describe()
        Console.WriteLine(room);
        foreach (var p in room.People)
            Console.WriteLine(p.Describe());
    }
}
