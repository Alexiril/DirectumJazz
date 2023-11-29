import QtQuick 2.0
import Sailfish.Silica 1.0
import Directum.Network 1.0


Page {
    objectName: "menu"
    allowedOrientations: Orientation.Portrait
    UserLogin{
        id: userlogin
    }
    SectionHeader {
        objectName: "mainHeader"
        anchors {horizontalCenter: parent.horizontalCenter}
        text: qsTr(userlogin.function_user_login())
    }
}

