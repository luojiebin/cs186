package edu.berkeley.cs186.database.common;

import edu.berkeley.cs186.database.common.BacktrackingIterator;

/**
 * Backtracking iterator over an array.
 */
public class ArrayBacktrackingIterator<T> implements BacktrackingIterator<T> {
  private T[] array = null;
  private int currentIndex = 0;
  private int markedIndex = -1;

  public ArrayBacktrackingIterator(T[] array) {
    this.array = array;
  }

  public boolean hasNext() {
    return currentIndex < array.length;
  }

  public T next() {
    return array[currentIndex++];
  }

  public void mark() {
    if (this.currentIndex == 0) {
      return;
    }
    this.markedIndex = this.currentIndex;
  }

  public void reset() {
    if (this.markedIndex == -1) {
      return;
    }
    this.currentIndex = this.markedIndex - 1;
  }
}

