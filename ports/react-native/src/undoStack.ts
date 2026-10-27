/** A reversible change to an immutable document: the command pattern. */
export interface EditCommand<D> {
    /** Short name for an "Undo …" label. */
    readonly name: string;
    /** Returns the document with the change applied. */
    readonly apply: (document: D) => D;
    /** Returns the document with the change taken back. */
    readonly revert: (document: D) => D;
}

/**
 * A document with undo and redo history of bounded length.
 *
 * A new command clears the redo history. Beyond `limit` steps the oldest one is dropped.
 */
export class UndoStack<D> {
    /** Most commands kept for undo. */
    readonly limit: number;
    #document: D;
    readonly #done: EditCommand<D>[] = [];
    readonly #undone: EditCommand<D>[] = [];

    /** A `limit` below 1, or one that is not a finite number, is treated as 1. */
    constructor(document: D, limit = 100) {
        this.#document = document;
        this.limit =
            Number.isFinite(limit) && limit >= 1 ? Math.floor(limit) : 1;
    }

    get document(): D {
        return this.#document;
    }

    get canUndo(): boolean {
        return this.#done.length > 0;
    }

    get canRedo(): boolean {
        return this.#undone.length > 0;
    }

    get undoName(): string | undefined {
        return this.#done.at(-1)?.name;
    }

    get redoName(): string | undefined {
        return this.#undone.at(-1)?.name;
    }

    /** Applies `command`, records it and clears the redo history. */
    perform(command: EditCommand<D>): void {
        this.#document = command.apply(this.#document);
        this.#done.push(command);
        if (this.#done.length > this.limit)
            this.#done.splice(0, this.#done.length - this.limit);
        this.#undone.length = 0;
    }

    /** Takes back the last command. Returns `false` when there is nothing to undo. */
    undo(): boolean {
        const command = this.#done.pop();
        if (!command) return false;
        this.#document = command.revert(this.#document);
        this.#undone.push(command);
        return true;
    }

    /** Applies the last undone command again. Returns `false` when there is nothing to redo. */
    redo(): boolean {
        const command = this.#undone.pop();
        if (!command) return false;
        this.#document = command.apply(this.#document);
        this.#done.push(command);
        return true;
    }
}
