import Link from 'next/link';

const links = [
  { href: '/login', label: 'Login' },
  { href: '/dashboard', label: 'Dashboard' },
  { href: '/admin/users', label: 'Utilizatori' },
  { href: '/admin/roles', label: 'Roluri' },
  { href: '/audit', label: 'Audit' },
];

export default function HomePage() {
  return (
    <main style={{ padding: 32 }}>
      <h1>Aplicație Web Trasabilitate FAP</h1>
      <p>Frontend placeholder pentru Sprint 0.</p>
      <nav style={{ display: 'grid', gap: 12, marginTop: 24 }}>
        {links.map((link) => (
          <Link key={link.href} href={link.href}>
            {link.label}
          </Link>
        ))}
      </nav>
    </main>
  );
}
