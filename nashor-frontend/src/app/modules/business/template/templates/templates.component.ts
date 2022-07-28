import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { AngelMediaWatcherService } from '@angel/services/media-watcher';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormControl } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { AuthService } from 'app/core/auth/auth.service';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import moment from 'moment';
import { Observable, Subject, takeUntil } from 'rxjs';
import { ModalTemplatePreviewService } from '../modal-template-preview/modal-template-preview.service';
import { TemplateService } from '../template.service';
import { Template } from '../template.types';

@Component({
  selector: 'app-templates',
  templateUrl: './templates.component.html',
})
export class TemplatesComponent implements OnInit {
  count: number = 0;
  templates$!: Observable<Template[]>;

  private data!: AppInitialData;

  drawerMode!: 'side' | 'over';
  searchInputControl: FormControl = new FormControl();
  selectedTemplate!: Template;

  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _activatedRoute: ActivatedRoute,
    private _changeDetectorRef: ChangeDetectorRef,
    private _router: Router,
    private _angelMediaWatcherService: AngelMediaWatcherService,
    private _templateService: TemplateService,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _authService: AuthService,
    private _modalTemplatePreviewService: ModalTemplatePreviewService
  ) {}

  // -----------------------------------------------------------------------------------------------------
  // @ Lifecycle hooks
  // -----------------------------------------------------------------------------------------------------

  /**
   * On init
   */
  ngOnInit(): void {
    /**
     * checkSession
     */
    this._authService
      .checkSession()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
    /**
     * checkSession
     */
    /**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * isOpenModal
     */
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
    });
    /**
     * Get the templates
     */
    this.templates$ = this._templateService.templates$;
    /**
     *  Count Subscribe and readAll
     */
    this._templateService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((templates: Template[]) => {
        /**
         * Update the counts
         */
        this.count = templates.length;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     *  Count Subscribe
     */
    this._templateService.templates$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((templates: Template[]) => {
        /**
         * Update the counts
         */
        this.count = templates.length;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Subscribe to media changes
     */
    this._angelMediaWatcherService.onMediaChange$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe(({ matchingAliases }) => {
        /**
         * Set the drawerMode if the given breakpoint is active
         */
        if (matchingAliases.includes('lg')) {
          this.drawerMode = 'side';
        } else {
          this.drawerMode = 'over';
        }
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
  }

  /**
   * On destroy
   */
  ngOnDestroy(): void {
    // Unsubscribe from all subscriptions
    this._unsubscribeAll.next(null);
    this._unsubscribeAll.complete();
  }

  // -----------------------------------------------------------------------------------------------------
  // @ Public methods
  // -----------------------------------------------------------------------------------------------------
  /**
   * Create Plantilla
   */
  createTemplate(): void {
    this._angelConfirmationService
      .open({
        title: 'Añadir template',
        message:
          '¿Estás seguro de que deseas añadir una nueva template? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const id_user_ = this.data.user.id_user;
          const id_company = this.data.user.company.id_company;
          /**
           * Create the template
           */
          this._templateService
            .create(id_user_, id_company)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (_template: Template) => {
                if (_template) {
                  this._notificationService.success(
                    'Plantilla agregada correctamente'
                  );
                  /**
                   * Go to new template
                   */
                  this.openModalTemplatePreview(_template.id_template);
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                this._notificationService.error(
                  !error.error
                    ? '¡Error interno!, consulte al administrador.'
                    : !error.error.description
                    ? '¡Error interno!, consulte al administrador.'
                    : error.error.description
                );
              },
            });
        }
        this._layoutService.setOpenModal(false);
      });
  }
  /**
   * Format the given ISO_8601 date as a relative date
   *
   * @param date
   */
  formatDateAsRelative(date: string): string {
    return moment(date, moment.ISO_8601).locale('es').fromNow();
  }
  /**
   * openModalTemplatePreview
   */
  openModalTemplatePreview(id_template: string): void {
    const editMode: boolean = true;

    this._modalTemplatePreviewService.openModalTemplatePreview(
      id_template,
      editMode
    );
  }
  /**
   * Track by function for ngFor loops
   *
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
