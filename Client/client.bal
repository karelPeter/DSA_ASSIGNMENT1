import ballerina/io;
import ballerina/http;

type Lecturer record {
    string staffNumber?;
    string officeNumber?;
    string staffName?;
    string title?;
    string[] courses?;
};

public function main() returns error? {
    http:Client lecturerClient = check new ("localhost:4000/lecturer");

    io:println("1. Create Lecturer");
    io:println("2. Update Lecturer");
    io:println("3. Delete Lecturer");
    io:println("4. View All Lecturers");
    io:println("5. View Lecturer By Staff Number");
    io:println("6. View Lecturer By Name");
    string option = io:readln("Choose an option: ");

    match option {
        "1" => {
            Lecturer lecturer = {};
            lecturer.staffNumber = io:readln("Enter Staff Number: ");
            lecturer.staffName = io:readln("Enter Staff Name: ");
            lecturer.officeNumber = io:readln("Enter Office Number: ");
            lecturer.title = io:readln("Enter Title: ");
            string courseName = addCourses();
            lecturer.courses = [courseName];
            check create(lecturerClient, lecturer);
        }
        "2" => {
            Lecturer lecturer = {};
            lecturer.staffNumber = io:readln("Enter Staff Number: ");
            lecturer.staffName = io:readln("Enter Staff Name: ");
            lecturer.officeNumber = io:readln("Enter Office Number: ");
            lecturer.title = io:readln("Enter Title: ");
            check update(lecturerClient, lecturer);
        }
        "3" => {
            string staffNumber = io:readln("Enter Staff Number: ");
            check delete(lecturerClient, staffNumber);
        }
        "4" => {
            check getAll(lecturerClient);
        }
        "5" => {
            string staffNumber = io:readln("Enter Staff Number: ");
            check getByStaffNumber(lecturerClient, staffNumber);
        }
        "6" => {
            string staffName = io:readln("Enter Staff Name: ");
            check getByStaffName(lecturerClient, staffName);
        }
        _ => {
            io:println("Invalid Key");
            check main();
        }
    }
}

function addCourses() returns string {
    string courseName = io:readln("Enter Course Name: ");
    return courseName;
}

// Function to create a lecturer

public function create(http:Client http, Lecturer lecturer) returns error? {
    if (http is http:Client) {
        string message = check http->/createLecturer.post(lecturer);
        io:println(message);
        string exit = io:readln("Press 9 to go back");

        if (exit === "9") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}

public function update(http:Client http, Lecturer newLecturer) returns error? {
    // Implement the logic to update a lecturer
    io:println(newLecturer);
}

public function delete(http:Client http, string staffNumber) returns error? {
    if (http is http:Client) {
        string message = check http->/deleteLecturerByStaffNumber.get({staffNumber});
        io:println(message);
        io:println("--------------------------");
        string exit = io:readln("Press 9 to go back");
        if (exit == "9") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}

public function getAll(http:Client http) returns error? {
    if (http is http:Client) {
        Lecturer[] lecturers = check http->/getAllLecturers;
        foreach Lecturer item in lecturers {
            io:println("--------------------------");
            io:println("Staff Number: ", item.staffNumber);
            io:println("Staff Name: ", item.staffName);
            io:println("Office Number: ", item.officeNumber);
            io:println("Title: ", item.title);
            io:println("Courses: ", item.courses);
        }

        io:println("--------------------------");
        string exit = io:readln("Press 9 to go back");

        if (exit == "9") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}

public function getByStaffNumber(http:Client http, string staffNumber) returns error? {
    if (http is http:Client) {
        Lecturer lecturer = check http->/getLecturerByStaffNumber(staffNumber = staffNumber);
        io:println("--------------------------");
        io:println("Staff Number: ", lecturer.staffNumber);
        io:println("Staff Name: ", lecturer.staffName);
        io:println("Office Number: ", lecturer.officeNumber);
        io:println("Title: ", lecturer.title);
        io:println("Courses: ", lecturer.courses);
        io:println("--------------------------");
        string exit = io:readln("Press 9 to go back");

        if (exit == "9") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}

public function getByStaffName(http:Client http, string staffName) returns error? {
    if (http is http:Client) {
        Lecturer lecturer = check http->/getLecturerByStaffName(staffName = staffName);
        io:println("--------------------------");
        io:println("Staff Number: ", lecturer.staffNumber);
        io:println("Staff Name: ", lecturer.staffName);
        io:println("Office Number: ", lecturer.officeNumber);
        io:println("Title: ", lecturer.title);
        io:println("Courses: ", lecturer.courses);
        io:println("--------------------------");
        string exit = io:readln("Press 0 to go back");

        if (exit == "0") {
            error? mainResult = main();
            if mainResult is error {
                io:println("Error, You can't go back.");
            }
        }
    }
}
