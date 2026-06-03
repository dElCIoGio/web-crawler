package engine

import (
	"context"
)

type Runner struct {
	Steps []SagaStep
}

func (r *Runner) Run(ctx context.Context, sagaCtx *SagaContext) error {
	completedSteps := make([]SagaStep, 0)

	for _, step := range r.Steps {
		if err := ctx.Err(); err != nil {
			return err
		}

		err := step.Execute(ctx, sagaCtx)
		if err != nil {
			r.compensate(ctx, sagaCtx, completedSteps)
			return err
		}

		completedSteps = append(completedSteps, step)
	}

	return nil
}

func (r *Runner) compensate(
	ctx context.Context,
	sagaCtx *SagaContext,
	completedSteps []SagaStep,
) {
	for i := len(completedSteps) - 1; i >= 0; i-- {
		step := completedSteps[i]
		_ = step.Compensate(ctx, sagaCtx)
	}
}
