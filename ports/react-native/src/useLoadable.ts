import { useCallback, useEffect, useRef, useState } from "react";

import { fail, idle, type Loadable, startLoading, succeed } from "./loadable";

/**
 * Runs `fetch` and keeps its result as a {@link Loadable}: the view model of MVVM as a hook.
 *
 * Only the newest load may change the state: when `reload` runs while an older load is still
 * pending, the older result is dropped. Results that arrive after the component unmounted are
 * dropped too.
 */
export function useLoadable<T>(fetch: () => Promise<T>): {
    state: Loadable<T>;
    reload: () => Promise<void>;
} {
    const [state, setState] = useState<Loadable<T>>(idle);
    const generation = useRef(0);
    const mounted = useRef(true);
    const latestFetch = useRef(fetch);
    latestFetch.current = fetch;

    useEffect(() => {
        mounted.current = true;
        return () => {
            mounted.current = false;
        };
    }, []);

    const reload = useCallback(async () => {
        const current = ++generation.current;
        setState(startLoading);
        let next: (state: Loadable<T>) => Loadable<T>;
        try {
            const value = await latestFetch.current();
            next = () => succeed(value);
        } catch (error) {
            next = (state) => fail(state, error);
        }
        if (mounted.current && current === generation.current) setState(next);
    }, []);

    return { state, reload };
}
