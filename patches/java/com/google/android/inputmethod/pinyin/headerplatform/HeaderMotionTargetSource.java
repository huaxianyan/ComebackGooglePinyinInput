package com.google.android.inputmethod.pinyin.headerplatform;

import android.view.View;
import java.util.Collection;

/** Native renderers expose their chrome, labels and motion holders, not arbitrary descendants. */
public interface HeaderMotionTargetSource {
    void appendHeaderMotionTargets(Collection<View> targets);
}
