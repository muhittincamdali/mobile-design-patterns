/** One accepted event of a {@link StateMachine}. */
export interface Transition<S, E> {
    readonly from: S;
    readonly event: E;
    readonly to: S;
}

/**
 * A finite state machine whose transitions are one function: the state pattern.
 *
 * The function returns the next state, or `undefined` when the event is not allowed in the
 * current state; refused events keep the state.
 */
export class StateMachine<S, E> {
    #state: S;
    readonly #transition: (state: S, event: E) => S | undefined;

    constructor(initial: S, transition: (state: S, event: E) => S | undefined) {
        this.#state = initial;
        this.#transition = transition;
    }

    /** The current state. */
    get state(): S {
        return this.#state;
    }

    /** Applies `event` and returns the transition, or `undefined` when it is not allowed. */
    send(event: E): Transition<S, E> | undefined {
        const to = this.#transition(this.#state, event);
        if (to === undefined) return undefined;
        const transition = { from: this.#state, event, to };
        this.#state = to;
        return transition;
    }

    /** Whether `event` would be accepted now. */
    canSend(event: E): boolean {
        return this.#transition(this.#state, event) !== undefined;
    }
}
