/*******************************************************************************
**
** Copyright (C) 2022 ru.directum
**
** This file is part of the Directum Jazz project.
**
** Redistribution and use in source and binary forms,
** with or without modification, are permitted provided
** that the following conditions are met:
**
** * Redistributions of source code must retain the above copyright notice,
**   this list of conditions and the following disclaimer.
** * Redistributions in binary form must reproduce the above copyright notice,
**   this list of conditions and the following disclaimer
**   in the documentation and/or other materials provided with the distribution.
** * Neither the name of the copyright holder nor the names of its contributors
**   may be used to endorse or promote products derived from this software
**   without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
** AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
** THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
** FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
** FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
** OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
** PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS;
** OR BUSINESS INTERRUPTION)
** HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
** WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE)
** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
** EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
*******************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import Directum.Network 1.0

Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.Portrait

    Column {
        id: layout
        objectName: "layout"
        width: parent.width

        PageHeader {
            objectName: "pageHeader"
            title: qsTr("Directum Jazz")
            extraContent.children: [
                IconButton {
                    objectName: "aboutButton"
                    icon.source: "image://theme/icon-m-about"
                    anchors.verticalCenter: parent.verticalCenter

                    onClicked: {
                        console.log("About page is opening")
                        pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                    }
                }
            ]
        }

        SectionHeader {
            objectName: "mainHeader"
            anchors {horizontalCenter: parent.horizontalCenter}
            text: qsTr("Вход в приложение ")
        }

        Label {
            objectName: "mainText"
            anchors { left: parent.left; right: parent.right; margins: Theme.horizontalPageMargin }
            color: palette.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            text: qsTr("Введите логин")
        }
        TextField{
            id: login
            width: parent.wight
            anchors { left: parent.left; right: parent.right; margins: Theme.horizontalPageMargin }
            placeholderText: qsTr("Введите логин")
            inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhUrlCharactersOnly
            EnterKey.onClicked: console.log(text)
        }
        Label {
            objectName: "mainText"
            anchors { left: parent.left; right: parent.right; margins: Theme.horizontalPageMargin }
            color: palette.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            text: qsTr("Введите пароль")
        }
        TextField{
            id: password
            width: parent.wight
            anchors { left: parent.left; right: parent.right; margins: Theme.horizontalPageMargin }
            placeholderText: qsTr("Введите пароль")
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhUrlCharactersOnly
            EnterKey.onClicked: console.log(text)
        }
        Auth {
            id: auth
            function auth_finished() {
                console.log("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                if (auth_result === Auth.Error) {
                    console.log("Error happened");
                    console.log(auth.auth_err);
                    error_label.text = qsTr("произошла ошибка");
                }
                if (auth_result === Auth.Okay) {
                    PageStack.push(Qt.resolvedUrl("Menu.qml"))
                }
                return 0;
            }
        }
        Label {
            id: error_label
            anchors { left: parent.left; right: parent.right; margins: Theme.horizontalPageMargin }
            color: palette.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            text: "hcggdgfgd"
        }
        Button{
            objectName: "EnterButton"
            anchors{horizontalCenter: parent.horizontalCenter}
            preferredWidth: Theme.buttonWidthMedium
            text: "Войти"

            onClicked: {
                auth.try_auth(login.text, password.text);
            }
        }
    }
}
