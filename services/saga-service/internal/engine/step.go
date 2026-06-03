package engine

import (
	"context"
)

type SagaContext struct {
	SagaID        string
	CorrelationID string
	Data          map[string]any
}

type SagaStep interface {
	Name() string
	Execute(ctx context.Context, sagaCtx *SagaContext) error
	Compensate(ctx context.Context, sagaCtx *SagaContext) error
}
