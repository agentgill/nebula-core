/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 2019-08-09
 * @description A LazyIterator that will allow a limited number of items to be taken from the underlying iterator
 */

public class LazyTakeIterator extends LazyIterator implements LazyIteratorMutator {

    private Integer nItemsToTake;

    public LazyTakeIterator(Iterator<Object> iterator, Integer nItemsToTake) {
        super(iterator);
        this.nItemsToTake = nItemsToTake;
    }

    public override Object next() {
        if(nItemsToTake-- > 0) {
            return super.next();
        } else {
            throw new NoSuchElementException();
        }
    }

    public override Boolean hasNext() {
        if(nItemsToTake > 0) {
            return super.hasNext();
        } else {
            return false;
        }
    }
}
