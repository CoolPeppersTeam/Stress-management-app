package tests

import (
	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"github.com/slickip/Stress-management-app/backend/WebSocket"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
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
