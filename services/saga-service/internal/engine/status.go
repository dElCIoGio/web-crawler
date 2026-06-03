package engine

type STATUS string

const (
	STARTED      STATUS = "started"
	IN_PROGRESS  STATUS = "in progress"
	COMPLETED    STATUS = "completed"
	FAILED       STATUS = "failed"
	COMPENSATING STATUS = "compensating"
	COMPENSATED  STATUS = "compensated"
)
