import QtQuick 2.0
import Sailfish.Silica 1.0
import Directum.Network 1.0


Page {
    objectName: "menuPage"
    allowedOrientations: Orientation.Portrait

    DirectumData {
        id: directumData
    }

    ButtonLayout {

        PageHeader {
            id: menuHeader
            objectName: "menuHeader"
            anchors {horizontalCenter: parent.horizontalCenter}
            title: directumData.get_user_login()
        }

        Button {
            id: recent
            text: qsTr("Assignments")
            anchors{horizontalCenter: parent.horizontalCenter;
                margins: Theme.horizontalPageMargin
                top: menuHeader.bottom
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("AssignmentsViewer.qml"));
            }
        }

//        Button {
//            id: a
//            text: "1"
//            anchors{horizontalCenter: parent.horizontalCenter;
//                margins: Theme.horizontalPageMargin
//                top: recent.bottom
//            }
//            onClicked: {}
//        }

//        Button {
//            id: b
//            text: "2"
//            anchors{horizontalCenter: parent.horizontalCenter;
//                margins: Theme.horizontalPageMargin
//                top:  a.bottom
//            }
//            onClicked: {}
//        }

//        Button {
//            id: c
//            text: "3"
//            anchors{horizontalCenter: parent.horizontalCenter;
//                margins: Theme.horizontalPageMargin
//                top: b.bottom
//            }
//            onClicked: {}
//        }
    }
}

