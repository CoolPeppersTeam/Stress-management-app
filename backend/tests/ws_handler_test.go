package tests

import (
	"net/http/httptest"
	"testing"

	"github.com/CoolPeppersTeam/Stress-management-app/backend/WebSocket"
	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"github.com/stretchr/testify/assert"
)

func TestHandleWS_ConnectionSuccess(t *testing.T) {
	gin.SetMode(gin.TestMode)

	hub := WebSocket.NewHub()
	r := gin.New()
	r.GET("/ws", WebSocket.HandleWS(hub))

	ts := httptest.NewServer(r)
	defer ts.Close()

	wsURL := "ws" + ts.URL[4:] + "/ws"

	conn, resp, err := websocket.DefaultDialer.Dial(wsURL, nil)
	if err != nil {
		t.Fatalf("Dial error: %v (status: %v)", err, resp)
	}
	defer conn.Close()

	assert.Equal(t, 101, resp.StatusCode)
}
