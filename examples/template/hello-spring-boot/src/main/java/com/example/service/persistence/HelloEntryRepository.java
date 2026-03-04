package {{ values.package }}.persistence;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link HelloEntry}.
 */
@Repository
public interface HelloEntryRepository extends JpaRepository<HelloEntry, Long> {
}
