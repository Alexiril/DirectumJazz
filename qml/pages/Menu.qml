import QtQuick 2.0
import Sailfish.Silica 1.0
import Directum.Network 1.0


Page {
    objectName: "menuPage"
    allowedOrientations: Orientation.Portrait

    DirectumData {
        id: directumData
        onGetRequestIsFinished: {
            if (request_answer_code !== 200)
            {
                requestAnswer.color = "red";
                requestAnswer.text = request_answer;
            }
            else
            {
                requestAnswer.color = "black";
                requestAnswer.text = json2string(string2json(request_answer), false)
            }
        }
    }

    PageHeader {
        id: menuHeader
        objectName: "menuHeader"
        anchors {horizontalCenter: parent.horizontalCenter}
        title: directumData.get_user_login()
    }

    Label {
        id: requestAnswer
        objectName: "requestAnswer"
        anchors { left: parent.left; right: parent.right; top: menuHeader.bottom; margins: Theme.horizontalPageMargin }
        wrapMode: Label.WordWrap
        text: ""
    }

    onVisibleChanged: {
        if (this.visible)
            directumData.make_get_request("GetTasksDisplayValues");
    }
}

