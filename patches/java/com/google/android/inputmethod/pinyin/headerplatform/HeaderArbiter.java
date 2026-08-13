package com.google.android.inputmethod.pinyin.headerplatform;

import java.util.Collection;

/** Pure arbitration logic. It owns priority and coexistence; modules never hide each other. */
public final class HeaderArbiter {
    public HeaderRenderPlan resolve(Collection<HeaderContribution> contributions,
            long sessionToken, long headerToken, boolean nativeCandidatesActive,
            long renderGeneration) {
        if (contributions == null || contributions.isEmpty()
                || sessionToken <= 0L || headerToken <= 0L) {
            if (nativeCandidatesActive) {
                return new HeaderRenderPlan(true, null, null, null, renderGeneration);
            }
            return new HeaderRenderPlan(false, null, null, null, renderGeneration);
        }

        HeaderContribution center = null;
        HeaderContribution leading = null;
        HeaderContribution trailing = null;
        for (HeaderContribution contribution : contributions) {
            if (contribution == null || contribution.getSessionToken() != sessionToken
                    || contribution.getHeaderToken() != headerToken) continue;
            if (contribution.getPresentationKind()
                    == HeaderPresentationKind.NATIVE_CANDIDATE) continue;
            HeaderPlacement placement = contribution.getPlacement();
            if (placement == HeaderPlacement.CENTER_CONTENT
                    || placement == HeaderPlacement.EXCLUSIVE_CONTENT) {
                center = higher(center, contribution);
            } else if (placement == HeaderPlacement.LEADING_ACTION) {
                leading = higher(leading, contribution);
            } else if (placement == HeaderPlacement.TRAILING_ACTION) {
                trailing = higher(trailing, contribution);
            } else if (placement == HeaderPlacement.PERSISTENT_ACTION) {
                if (trailing == null) trailing = contribution;
                else trailing = higher(trailing, contribution);
            }
        }

        // The native Candidate layer always wins while it has real content. This includes
        // dismissible Clipboard Candidates; withdrawing them naturally restores Inline Autofill.
        if (nativeCandidatesActive) {
            return new HeaderRenderPlan(true, null, null, null, renderGeneration);
        }
        if (center != null && (center.getPlacement() == HeaderPlacement.EXCLUSIVE_CONTENT
                || !center.allowsActions())) {
            leading = null;
            trailing = null;
        }
        if (center == null && leading == null && trailing == null) {
            return new HeaderRenderPlan(false, null, null, null, renderGeneration);
        }
        return new HeaderRenderPlan(false, center, leading, trailing, renderGeneration);
    }

    private HeaderContribution higher(HeaderContribution current,
            HeaderContribution candidate) {
        if (current == null) return candidate;
        if (candidate.getPriority() > current.getPriority()) return candidate;
        if (candidate.getPriority() < current.getPriority()) return current;
        int moduleOrder = candidate.getModuleId().compareTo(current.getModuleId());
        if (moduleOrder < 0) return candidate;
        if (moduleOrder > 0) return current;
        return candidate.getStableId().compareTo(current.getStableId()) < 0
                ? candidate : current;
    }
}
