import ballerina/http;
import ballerina/io;

type Lecturer readonly & record {
    string staffNumber;
    string officeNumber?;
    string staffName?;
    string title?;
    string[] lectures?;
};

type staffNumber string;

table<Lecturer> key(staffNumber) lecturers = table [];

// http:localhost:400/course
service /course on new http:Listener(4000) {
    resource function post createCourse(Lecturer lecturer) returns string {
        io:println(lecturer);
        error? err = lecturers.add(lecturer);
        if (err is error) {
            return string `Error, ${err.message()}`;
        }
        return string `{lecturer.staffName} saved successfully`;
    }

    resource function put updateCourse(Lecturer lecturer) returns string {
        io:println(lecturer);
        error? err = lecturers.put(lecturer);
        if (err is error) {
            return string `Error, ${err.message()}`;
        }
        return string `{lecturer.staffName} saved successfully`;
    }
    
    resource function get getAllCourses() returns table<Lecturer> key(staffNumber) {
        return lecturers;
    }

    resource function get getCourseByCode(string code) returns Lecturer|string {
        foreach Lecturer lecturer in lecturers {
            if (lecturer.staffNumber == code) {
                return lecturer;
            }
        }

        return code + " is invalid";
    }

    resource function get getCourseByName/[string staffName]() returns Lecturer|string {
        foreach Lecturer lecturer in lecturers {
            if (lecturer.staffName == staffName) {
                return lecturer;
            }
        }

        return staffName + " doesn't exist";
    }

    resource function delete deleteCourseByName/[string staffName]() returns string {
        lecturers = <table<Lecturer> key(staffNumber)>lecturers.filter((lecturer) => lecturer.staffName != staffName);

        if (lecturers.length() == 0) {
            return staffName + " not found.";
        }
        return staffName + " successfully deleted";
    }
}
