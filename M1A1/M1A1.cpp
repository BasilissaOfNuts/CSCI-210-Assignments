/* Program name: M1A1.cpp
*  Author: Stella Song
*  Date last updated: 2026/03/20
* Purpose: File I/O Assignment
*/

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iomanip>
#include <ctime>

using namespace std;

// Struct for participant info
struct Participant {
    int id {};
    string firstName;
    string lastName;
    int age {};
    string gender;
    bool receivesStudyMor {}; // 0 = false, 1 = true in survey.dat
};

// Struct for survey info
struct Survey {
    string date;
    int participantId {};
    string headaches;
    string constipation;
    string sleepDifficulty;
    string otherSideEffects;
    string studyMore;
};

string getCurrentDate() {
    char formatDate[80];
    const time_t currentDate = time(nullptr);
    strftime(formatDate, 80, "%F", localtime(&currentDate));
    return {formatDate};
}

vector<Participant> loadParticipants() {
    vector<Participant> participants;

    if (ifstream file("participant.dat"); file.is_open()) {
        Participant p;
        int receivesMor;

        while (file >> p.id >> p.firstName >> p.lastName >> p.age >> p.gender >> receivesMor) {
            p.receivesStudyMor = (receivesMor == 1);
            participants.push_back(p);
        }

        file.close();
    }

    return participants;
}

void saveParticipants(const vector<Participant>& participants) {
    if (ofstream file("participant.dat"); file.is_open()) {
        for (const auto&[id, firstName, lastName, age, gender, receivesStudyMor] : participants) {
            file << id << " " << firstName << " " << lastName << " "
                 << age << " " << gender << " " << (receivesStudyMor ? 1 : 0) << endl;
        }

        file.close();
    }
}

void addParticipant(vector<Participant>& participants) {
    Participant newParticipant;

    // Determine next participant ID
    if (participants.empty()) newParticipant.id = 1;
    else newParticipant.id = participants.back().id + 1;

    cout << "Enter the participant's first name: ";
    cin >> newParticipant.firstName;

    cout << "Enter the participant's last name: ";
    cin >> newParticipant.lastName;

    cout << "Enter " << newParticipant.firstName << " " << newParticipant.lastName << "'s age: ";
    cin >> newParticipant.age;

    cout << "Enter " << newParticipant.firstName << " " << newParticipant.lastName << "'s gender: ";
    cin >> newParticipant.gender;

    // Assign StudyMor based on ID
    if (newParticipant.id % 2 == 0) newParticipant.receivesStudyMor = true; // Even - StudyMor
    else newParticipant.receivesStudyMor = false; // Odd - placebo

    participants.push_back(newParticipant);
    saveParticipants(participants);

    cout << "\nParticipant added successfully! ID: " << newParticipant.id << endl;
    cout << "Assigned: " << (newParticipant.receivesStudyMor ? "StudyMor" : "Placebo") << endl << endl;
}

void displayParticipants(const vector<Participant>& participants) {
    if (participants.empty()) {
        cout << "No participants found." << endl << endl;
        return;
    }

    for (const auto&[id, firstName, lastName, age, gender, receivesStudyMor] : participants) {
        cout << "ID: " << id << endl;
        cout << "Name: " << firstName << " " << lastName << endl;
        cout << "Age: " << age << endl;
        cout << "Gender: " << gender << endl;
        cout << "StudyMor: " << (receivesStudyMor ? "Yes" : "No") << endl;
        cout << "**************************************************" << endl;
    }

    cout << endl;
}

void displayParticipantsForSelection(const vector<Participant>& participants) {
    if (participants.empty()) {
        cout << "No participants found. Please add participants first." << endl;
        return;
    }

    for (const auto&[id, firstName, lastName, age, gender, receivesStudyMor] : participants) {
        cout << "ID: " << id << endl;
        cout << "Name: " << firstName << " " << lastName << endl;
        cout << "Age: " << age << endl;
        cout << "Gender: " << gender << endl;
        cout << "StudyMor: " << (receivesStudyMor ? "Yes" : "No") << endl;
        cout << "**************************************************" << endl;
    }
}

void saveSurvey(const Survey& survey) {
    if (ofstream file("survey.dat", ios::app); file.is_open()) {
        file << survey.date << "|" << survey.participantId << "|"
             << survey.headaches << "|" << survey.constipation << "|"
             << survey.sleepDifficulty << "|" << survey.otherSideEffects << "|"
             << survey.studyMore << endl;
        file.close();
    }
}

void collectSurvey(const vector<Participant>& participants) {
    if (participants.empty()) {
        cout << "No participants found. Please add participants first." << endl << endl;
        return;
    }

    cout << "Please choose the study participant:" << endl;
    displayParticipantsForSelection(participants);

    int choice;
    cout << "Enter participant ID: ";
    cin >> choice;

    // Find chosen participant
    const Participant* selectedParticipant = nullptr; // yuck pointers Java on top!!! kidding :3
    for (const auto& p : participants) {
        if (p.id == choice) {
            selectedParticipant = &p;
            break;
        }
    }

    if (selectedParticipant == nullptr) {
        cout << "Invalid participant ID." << endl << endl;
        return;
    }

    cout << "\nAsk the participant the following questions and enter their responses." << endl;

    Survey newSurvey;
    newSurvey.date = getCurrentDate();
    newSurvey.participantId = selectedParticipant->id;

    cin.ignore(); // Clear input before questions

    cout << "1. Did you have any headaches using StudyMor? ";
    getline(cin, newSurvey.headaches);

    cout << "2. Did you have any constipation using StudyMor? ";
    getline(cin, newSurvey.constipation);

    cout << "3. Did you experience any difficulty sleeping while using StudyMor? ";
    getline(cin, newSurvey.sleepDifficulty);

    cout << "4. List any other potential side effects, you experienced using StudyMor. ";
    getline(cin, newSurvey.otherSideEffects);

    cout << "5. Did you feel like you could study more using StudyMor? ";
    getline(cin, newSurvey.studyMore);

    saveSurvey(newSurvey);
    cout << "\nSurvey data collected and saved successfully!" << endl << endl;
}

int main() {
    vector<Participant> participants = loadParticipants();
    int choice;

    cout << "Welcome to the Westlake Research Hospital StudyMor Study!" << endl << endl;

    do {
        cout << "1. Add a New Participant" << endl;
        cout << "2. Collect Survey for Participant" << endl;
        cout << "3. Display Participants" << endl;
        cout << "4. Quit" << endl;
        cout << "\nPlease enter a command to continue: ";
        cin >> choice;
        cout << endl;

        switch (choice) {
            case 1:
                addParticipant(participants);
                break;
            case 2:
                collectSurvey(participants);
                break;
            case 3:
                displayParticipants(participants);
                break;
            case 4:
                cout << "Goodbye!" << endl;
                break;
            default:
                cout << "Invalid option. Please try again." << endl << endl;
        }
    } while (choice != 4);

    return 0;
}